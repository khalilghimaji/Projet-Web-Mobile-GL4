import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDu3csG0jkDh1Z0KznuJH6OHzcyVdidVD0',
    appId: '1:331412109912:web:c2e9d98ce2ea2b3080a82d',
    messagingSenderId: '331412109912',
    projectId: 'projetflutter-4f6d2',
    authDomain: 'projetflutter-4f6d2.firebaseapp.com',
    storageBucket: 'projetflutter-4f6d2.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAHMekac2ixKrfMtLCdfbimuTncgcqG3F0',
    appId: '1:331412109912:android:a72d9242da58a61780a82d',
    messagingSenderId: '331412109912',
    projectId: 'projetflutter-4f6d2',
    storageBucket: 'projetflutter-4f6d2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTgNyI4uEjRPEeP8ZBJdygQinCty8YcOw',
    appId: '1:331412109912:ios:5d1d8724f4d509a280a82d',
    messagingSenderId: '331412109912',
    projectId: 'projetflutter-4f6d2',
    storageBucket: 'projetflutter-4f6d2.firebasestorage.app',
    iosClientId: '331412109912-miunpnmem87bv1haetsqr8178mtpu8ej.apps.googleusercontent.com',
    iosBundleId: 'com.example.mobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBTgNyI4uEjRPEeP8ZBJdygQinCty8YcOw',
    appId: '1:331412109912:ios:5d1d8724f4d509a280a82d',
    messagingSenderId: '331412109912',
    projectId: 'projetflutter-4f6d2',
    storageBucket: 'projetflutter-4f6d2.firebasestorage.app',
    iosClientId: '331412109912-miunpnmem87bv1haetsqr8178mtpu8ej.apps.googleusercontent.com',
    iosBundleId: 'com.example.mobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDu3csG0jkDh1Z0KznuJH6OHzcyVdidVD0',
    appId: '1:331412109912:web:595dc04971c1b18c80a82d',
    messagingSenderId: '331412109912',
    projectId: 'projetflutter-4f6d2',
    authDomain: 'projetflutter-4f6d2.firebaseapp.com',
    storageBucket: 'projetflutter-4f6d2.firebasestorage.app',
  );

}