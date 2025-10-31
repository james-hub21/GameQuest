import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // As a workaround for the broken tool, we'll use the web config
    // for other platforms. This will let the app run without crashing.
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        // This will be caught by the app, but we need to return something.
        // We'll use the web config as a default.
        return web;
    }
  }

  // --- Manually added Web config ---
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyC4WXiKmNNJ3yL9hGxKEwj6fawMVD_Vm8Y",
    appId: "1:784790960034:web:1a3f52038efbbec6ae64fb",
    messagingSenderId: "784790960034",
    projectId: "gamequest-m",
    authDomain: "gamequest-m.firebaseapp.com",
    storageBucket: "gamequest-m.firebasestorage.app",
    measurementId: "G-066XFFDH9Y",
  );
  // --- End of Web config ---

  // As a workaround, we'll just point these to the web config.
  static const FirebaseOptions android = web;
  static const FirebaseOptions ios = web;
  static const FirebaseOptions macos = web;
}
