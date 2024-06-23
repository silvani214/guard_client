import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  final double width;
  final double height;

  PlaceholderImage({this.width = 100, this.height = 100});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300], // Background color for the placeholder
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10), // Match the border radius
        child: Center(
          child: Image.asset(
            'assets/site_placeholder.png', // Replace with the path to your PNG logo
            width: 100, // Set a specific width
            fit: BoxFit.contain, // Ensure it fits well
          ),
        ),
      ),
    );
  }
}
