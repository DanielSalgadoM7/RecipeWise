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
    apiKey: 'AIzaSyBPIwU1ww_vXT7rngAN6B2m18x1v5rLrwY',
    appId: '1:918251788765:web:f2bcf5060777f5be9dfe34',
    messagingSenderId: '918251788765',
    projectId: 'recipewise-c2a3f',
    authDomain: 'recipewise-c2a3f.firebaseapp.com',
    storageBucket: 'recipewise-c2a3f.firebasestorage.app',
    measurementId: 'G-QCC196F1HV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAOYB7o-YQussxzZqmdq3Ku47JKrVX36Ng',
    appId: '1:918251788765:android:3264d6b49b7ba46b9dfe34',
    messagingSenderId: '918251788765',
    projectId: 'recipewise-c2a3f',
    storageBucket: 'recipewise-c2a3f.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAr_VYqWG3yP7ToWE5Kc_0K24ztJRts-I4',
    appId: '1:918251788765:ios:17c147396b343b6d9dfe34',
    messagingSenderId: '918251788765',
    projectId: 'recipewise-c2a3f',
    storageBucket: 'recipewise-c2a3f.firebasestorage.app',
    iosBundleId: 'com.recipewise.main',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAr_VYqWG3yP7ToWE5Kc_0K24ztJRts-I4',
    appId: '1:918251788765:ios:17c147396b343b6d9dfe34',
    messagingSenderId: '918251788765',
    projectId: 'recipewise-c2a3f',
    storageBucket: 'recipewise-c2a3f.firebasestorage.app',
    iosBundleId: 'com.recipewise.main',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBPIwU1ww_vXT7rngAN6B2m18x1v5rLrwY',
    appId: '1:918251788765:web:3ecd10979555de439dfe34',
    messagingSenderId: '918251788765',
    projectId: 'recipewise-c2a3f',
    authDomain: 'recipewise-c2a3f.firebaseapp.com',
    storageBucket: 'recipewise-c2a3f.firebasestorage.app',
    measurementId: 'G-RN15NPLDYY',
  );

}