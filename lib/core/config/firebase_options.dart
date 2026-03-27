import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    if (Platform.isIOS) {
      return ios;
    }
    if (Platform.isAndroid) {
      return android;
    }
    if (Platform.isMacOS) {
      return macos;
    }
    if (Platform.isWindows) {
      return windows;
    }
    if (Platform.isLinux) {
      return linux;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDelZyWcemEpu-jgAd1iwZgxBO4CBIl9Lo',
    appId: '1:267944691460:web:809a5b5300aaddc8',
    messagingSenderId: '267944691460',
    projectId: 'cospace-58fec',
    authDomain: 'cospace-58fec.firebaseapp.com',
    databaseURL: 'https://cospace-58fec.firebaseio.com',
    storageBucket: 'cospace-58fec.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDelZyWcemEpu-jgAd1iwZgxBO4CBIl9Lo',
    appId: '1:267944691460:android:809a5b5300aaddc8da3251',
    messagingSenderId: '267944691460',
    projectId: 'cospace-58fec',
    databaseURL: 'https://cospace-58fec.firebaseio.com',
    storageBucket: 'cospace-58fec.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDelZyWcemEpu-jgAd1iwZgxBO4CBIl9Lo',
    appId: '1:267944691460:ios:809a5b5300aaddc8',
    messagingSenderId: '267944691460',
    projectId: 'cospace-58fec',
    databaseURL: 'https://cospace-58fec.firebaseio.com',
    iosBundleId: 'com.example.cospace',
    storageBucket: 'cospace-58fec.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDelZyWcemEpu-jgAd1iwZgxBO4CBIl9Lo',
    appId: '1:267944691460:macos:809a5b5300aaddc8',
    messagingSenderId: '267944691460',
    projectId: 'cospace-58fec',
    databaseURL: 'https://cospace-58fec.firebaseio.com',
    iosBundleId: 'com.example.cospace',
    storageBucket: 'cospace-58fec.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDelZyWcemEpu-jgAd1iwZgxBO4CBIl9Lo',
    appId: '1:267944691460:windows:809a5b5300aaddc8',
    messagingSenderId: '267944691460',
    projectId: 'cospace-58fec',
    databaseURL: 'https://cospace-58fec.firebaseio.com',
    storageBucket: 'cospace-58fec.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyDelZyWcemEpu-jgAd1iwZgxBO4CBIl9Lo',
    appId: '1:267944691460:linux:809a5b5300aaddc8',
    messagingSenderId: '267944691460',
    projectId: 'cospace-58fec',
    databaseURL: 'https://cospace-58fec.firebaseio.com',
    storageBucket: 'cospace-58fec.firebasestorage.app',
  );
}
