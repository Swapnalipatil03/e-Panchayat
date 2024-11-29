import 'package:e_panchayat/view/chatbot/chatbot.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FullScreenGifSplashScreen extends StatefulWidget {
  @override
  _FullScreenGifSplashScreenState createState() =>
      _FullScreenGifSplashScreenState();
}

class _FullScreenGifSplashScreenState extends State<FullScreenGifSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next page after 4 seconds
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatBotScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors
              .white, // Optional: background color if the gif has transparency
          child: Image.asset(
            'assets/images/ai3.gif', // Replace with your GIF asset path
            fit: BoxFit.cover, // Ensure the GIF covers the entire screen
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Next Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Welcome to the next page!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
