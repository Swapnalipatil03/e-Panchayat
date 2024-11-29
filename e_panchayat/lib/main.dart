import 'dart:developer';

import 'package:e_panchayat/view/home/home.dart';
import 'package:e_panchayat/view/login/login.dart';
import 'package:e_panchayat/view/nav_bar.dart';
import 'package:e_panchayat/view/splash_screen/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyA4jaATo2vleUYUDye-4eDgQmVMQGsfm4E",
            appId: "284416909106",
            messagingSenderId: "1:284416909106:android:6bbd18e5afc0b26250c12b",
            projectId: "e-panchayat-f7aec")); // Initialize Firebase
    print("Firebase Initialized");
  } catch (e) {
    print("Firebase Initialization Error: $e");
  }
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(), // Display the Login screen
      //  home: NavBar(), // Display the Login screen
      debugShowCheckedModeBanner: false, // Remove the debug banner
    );
  }
}
