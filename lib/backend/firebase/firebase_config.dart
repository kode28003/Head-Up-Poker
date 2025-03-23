import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAJt-cGAmtkLdipk-7Jp3xJJX2eVUcVdPo",
            authDomain: "poker-3t5qom.firebaseapp.com",
            projectId: "poker-3t5qom",
            storageBucket: "poker-3t5qom.firebasestorage.app",
            messagingSenderId: "65175504519",
            appId: "1:65175504519:web:bcad39e3f92b9b9541da22"));
  } else {
    await Firebase.initializeApp();
  }
}
