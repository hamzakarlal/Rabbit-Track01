import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(AppConstants.usersCollection);

  Stream<String?> get authStateChanges =>
      _auth.authStateChanges().map((user) => user?.uid);

  String? get currentUser => _auth.currentUser?.uid;

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e));
    }
  }

  Future<String> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e));
    }
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e));
    }
  }

  Future<void> changePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AuthException(
        'You must be signed in to change your password.',
      );
    }
    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e));
    }
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await _users.doc(user.uid).delete();
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_authMessage(e));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> createUserDocument({
    required String userId,
    required String fullName,
    required String email,
    required String phoneNumber,
    required String farmId,
  }) async {
    final now = DateTime.now();
    final authUser = _auth.currentUser;
    final userModel = UserModel(
      id: userId,
      fullName: fullName.isNotEmpty ? fullName : (authUser?.displayName ?? ''),
      email: email.isNotEmpty ? email : (authUser?.email ?? ''),
      phoneNumber: phoneNumber,
      farmId: farmId,
      emailVerified: authUser?.emailVerified ?? false,
      createdAt: now,
      updatedAt: now,
    );

    await _users.doc(userId).set(userModel.toMap());
  }

  Future<UserModel?> getUserDocument(String userId) async {
    final doc = await _users.doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, userId);
  }

  Future<void> updateUserDocument(UserModel user) async {
    await _users.doc(user.id).set({
      ...user.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<UserModel?> userStream(String userId) {
    return _users
        .doc(userId)
        .snapshots()
        .map(
          (doc) => doc.exists ? UserModel.fromMap(doc.data()!, userId) : null,
        );
  }

  String _authMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Use at least ${AppConstants.minPasswordLength} characters.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'requires-recent-login':
        return 'Please sign in again to complete this action.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
