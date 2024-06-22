import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guard_client/ui/screens/home_screen.dart'; // Replace with your actual main screen import
import 'package:guard_client/ui/widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(), // Replace with your actual main screen widget
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/logo.png', // Replace with the path to your PNG logo
                width: 150, // Set a specific width
                height: 150, // Set a specific height
                fit: BoxFit.contain, // Ensure it fits well
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: LoadingIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
