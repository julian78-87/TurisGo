import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle primary() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.deepPurple,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    );
  }
}
