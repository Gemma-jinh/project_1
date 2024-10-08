// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyA0ni7O-zGFOqUSSe0sz1vTJxXYNtqfk20',
    appId: '1:906961788275:web:816173036a2fa9ee53f906',
    messagingSenderId: '906961788275',
    projectId: 'mycarwashapp-fd394',
    authDomain: 'mycarwashapp-fd394.firebaseapp.com',
    storageBucket: 'mycarwashapp-fd394.appspot.com',
    measurementId: 'G-3FYLYJZSTZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDBFYk4JkxQBC3SIQIfEQ8gCXgHXZkMfJg',
    appId: '1:906961788275:android:12ec3a404e5a08b453f906',
    messagingSenderId: '906961788275',
    projectId: 'mycarwashapp-fd394',
    storageBucket: 'mycarwashapp-fd394.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB-u413nyVzQ4dpw2SPkawIWeXrDvfGkig',
    appId: '1:906961788275:ios:f5e9449724884b6953f906',
    messagingSenderId: '906961788275',
    projectId: 'mycarwashapp-fd394',
    storageBucket: 'mycarwashapp-fd394.appspot.com',
    iosBundleId: 'com.example.myCarWashApp',
  );
}
