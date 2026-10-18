import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Future<String?> uploadImage({
    required File file,
    required String folder,
    String? existingUrl,
  }) async {
    try {
      // Delete existing image if any
      if (existingUrl != null && existingUrl.isNotEmpty) {
        await deleteImage(existingUrl);
      }

      // Compress image
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: 75,
        minWidth: 800,
        minHeight: 800,
      );

      if (compressedBytes == null) return null;

      final extension = path.extension(file.path).toLowerCase();
      final fileName = '${_uuid.v4()}$extension';
      final ref = _storage.ref().child('$folder/$fileName');

      final uploadTask = await ref.putData(
        compressedBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw StorageException('Failed to upload image: $e');
    }
  }

  Future<void> deleteImage(String url) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // Ignore deletion errors (image might already be deleted)
    }
  }

  Future<String?> uploadProfilePicture({
    required File file,
    required String userId,
  }) async {
    return uploadImage(file: file, folder: 'profiles/$userId');
  }

  Future<String?> uploadRabbitPhoto({
    required File file,
    required String farmId,
    required String rabbitId,
  }) async {
    return uploadImage(file: file, folder: 'farms/$farmId/rabbits/$rabbitId');
  }

  Future<String?> uploadFarmLogo({
    required File file,
    required String farmId,
  }) async {
    return uploadImage(file: file, folder: 'farms/$farmId/logo');
  }

  Future<String?> uploadExpenseReceipt({
    required File file,
    required String farmId,
  }) async {
    return uploadImage(file: file, folder: 'farms/$farmId/receipts');
  }
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);

  @override
  String toString() => message;
}
