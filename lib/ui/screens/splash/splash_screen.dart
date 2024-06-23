import 'dart:async';
import 'package:flutter/material.dart';
import 'package:guard_client/ui/screens/home_screen.dart'; // Replace with your actual main screen import
import 'package:guard_client/ui/widgets/loading_indicator.dart';
import 'package:guard_client/ui/widgets/logo.dart'; // Import the common logo widget

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Positioned(
              top: screenHeight * 0.15,
              left: 0,
              right: 0,
              child: Center(
                child: Logo(),
              ),
            ),
            Positioned(
              bottom: screenHeight * 0.08,
              left: 0,
              right: 0,
              child: Center(
                child: LoadingIndicator(),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
