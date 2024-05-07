
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAhAjFUygef57tJZqYL0apThvXjwiiw_io',
    appId: '1:695812321225:web:2f2e669a28dc8768be4218',
    messagingSenderId: '695812321225',
    projectId: 'mobileprjflutter',
    authDomain: 'mobileprjflutter.firebaseapp.com',
    storageBucket: 'mobileprjflutter.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9UJsLRCzKsuf-JLEejOA_quvvfZCDtgM',
    appId: '1:695812321225:android:7496877b1065f325be4218',
    messagingSenderId: '695812321225',
    projectId: 'mobileprjflutter',
    storageBucket: 'mobileprjflutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAaC1lRbTXtJy-oa30VoGONVfUsAazTpqo',
    appId: '1:695812321225:ios:8dabb7c53bc92407be4218',
    messagingSenderId: '695812321225',
    projectId: 'mobileprjflutter',
    storageBucket: 'mobileprjflutter.appspot.com',
    iosBundleId: 'com.example.projMobileFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAaC1lRbTXtJy-oa30VoGONVfUsAazTpqo',
    appId: '1:695812321225:ios:5c62aba73c1d8d09be4218',
    messagingSenderId: '695812321225',
    projectId: 'mobileprjflutter',
    storageBucket: 'mobileprjflutter.appspot.com',
    iosBundleId: 'com.example.projMobileFlutter.RunnerTests',
  );
}
