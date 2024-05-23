import 'package:flutter/material.dart';

class InitialsIcon extends StatelessWidget {
  final String name;

  InitialsIcon({required this.name});

  String getFirstLetter(String input) {
    if (input.isEmpty) return '';
    return input[0].toUpperCase();
  }

  Color _getColorForLetter(String letter) {
    // You can implement any color selection logic here
    switch (getFirstLetter(letter)) {
      case 'A':
      case 'B':
      case 'C':
        return Colors.red;
      case 'D':
      case 'E':
      case 'F':
        return Colors.blue;
      case 'G':
      case 'H':
      case 'I':
        return Colors.green;
      case 'J':
      case 'K':
      case 'L':
        return Colors.yellow;
      case 'M':
      case 'N':
      case 'O':
        return Colors.orange;
      case 'P':
      case 'Q':
      case 'R':
        return Colors.purple;
      case 'S':
      case 'T':
      case 'U':
        return Colors.teal;
      case 'V':
      case 'W':
      case 'X':
        return Colors.pink;
      case 'Y':
      case 'Z':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String _getInitials(String name) {
    List<String> words = name.split(' ');
    String initials = '';
    for (var word in words) {
      if (word.isNotEmpty) {
        initials += word[0].toUpperCase();
      }
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: _getColorForLetter(name),
      child: Text(
        _getInitials(name),
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
