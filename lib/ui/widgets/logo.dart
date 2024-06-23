import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png', // Replace with the path to your PNG logo
      width: 100, // Set a specific width
      fit: BoxFit.contain, // Ensure it fits well
    );
  }
}
