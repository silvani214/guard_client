import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final IconData icon;
  final String hintText;

  AuthTextField({
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.hintText = "",
    required this.icon,
  });

  @override
  _AuthTextFieldState createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: _isFocused
                  ? Color.fromARGB(200, 25, 74, 151)
                  : Colors.black12,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            obscureText: widget.isPassword,
            focusNode: _focusNode,
            style: TextStyle(
              fontSize: 16.0, // Set the font size
              fontWeight: FontWeight.normal, // Set the font weight
              color: Colors.black54, // Set the text color
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                // Style for the placeholder text
                color: Colors.black38,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
              border: InputBorder.none, // Remove default border
              enabledBorder: InputBorder.none, // Remove default enabled border
              focusedBorder: InputBorder.none, // Remove default focused border
              errorBorder: InputBorder.none, // Remove default error border
              disabledBorder:
                  InputBorder.none, // Remove default disabled border
              prefixIcon: Icon(widget.icon,
                  color: _isFocused
                      ? Color.fromARGB(200, 25, 74, 151)
                      : Colors.black12),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0), // Padding inside the TextField
            ),
          ),
        ),
      ],
    );
  }
}
