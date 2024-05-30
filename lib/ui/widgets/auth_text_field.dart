import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final IconData icon;
  late String hintText;

  AuthTextField({
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.hintText = "",
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        label,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      SizedBox(height: 8),
      TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            // Style for the placeholder text
            color: Colors.grey,
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon, color: Colors.black26),
        ),
      )
    ]);
  }
}
