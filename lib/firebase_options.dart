// This file is a placeholder for Firebase configuration.
// Replace this file with the actual google-services.json configuration.
// Run: flutterfire configure --project=your-firebase-project-id

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Replace these with your actual Firebase project configuration

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA1_f_TP_WYO-J6ranjuWVj-5r3rE39P54',
    appId: '1:765439714845:web:a74890976ae772330148f4',
    messagingSenderId: '765439714845',
    projectId: 'rabbit-track-android',
    authDomain: 'rabbit-track-android.firebaseapp.com',
    storageBucket: 'rabbit-track-android.firebasestorage.app',
    measurementId: 'G-3PHHKC74QB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBRYpp8F2LiHT5Z3ot9ox5lBz_5goJooIU',
    appId: '1:765439714845:android:aee4e8f02373672a0148f4',
    messagingSenderId: '765439714845',
    projectId: 'rabbit-track-android',
    storageBucket: 'rabbit-track-android.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR-IOS-API-KEY',
    appId: '1:YOUR-APP-ID:ios:YOUR-IOS-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'rabbit-track-app',
    storageBucket: 'rabbit-track-app.appspot.com',
    iosBundleId: 'com.rabbittrack.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR-MACOS-API-KEY',
    appId: '1:YOUR-APP-ID:ios:YOUR-MACOS-APP-ID',
    messagingSenderId: 'YOUR-SENDER-ID',
    projectId: 'rabbit-track-app',
    storageBucket: 'rabbit-track-app.appspot.com',
    iosBundleId: 'com.rabbittrack.app',
  );
}
