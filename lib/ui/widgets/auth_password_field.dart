import 'package:flutter/material.dart';

class AuthPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  late String hintText;

  AuthPasswordField(
      {required this.controller,
      required this.label,
      required this.icon,
      this.hintText = ""});

  @override
  _AuthPasswordFieldState createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.label,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      SizedBox(height: 8),
      TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: widget.hintText,
          hintStyle: TextStyle(
            // Style for the placeholder text
            color: Colors.grey,
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
          ),
          prefixIcon: Icon(widget.icon, color: Colors.black26),
          suffixIcon: IconButton(
            icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.black26),
            onPressed: _togglePasswordVisibility,
          ),
        ),
      )
    ]);
  }
}
