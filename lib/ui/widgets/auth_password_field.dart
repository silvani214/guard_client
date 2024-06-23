import 'package:flutter/material.dart';

class AuthPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String hintText;

  AuthPasswordField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hintText = "",
  });

  @override
  _AuthPasswordFieldState createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscureText = true;
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

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
            obscureText: _obscureText,
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
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: _isFocused
                      ? Color.fromARGB(200, 25, 74, 151)
                      : Colors.black12,
                ),
                onPressed: _togglePasswordVisibility,
              ),
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
