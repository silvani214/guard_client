import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final String initialValue;
  final String labelText;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  final int maxLines; // Add maxLines parameter

  FormTextField({
    required this.initialValue,
    required this.labelText,
    required this.validator,
    required this.onSaved,
    this.maxLines = 1, // Default to 1 for single-line text field
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLines: maxLines, // Use maxLines parameter
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
