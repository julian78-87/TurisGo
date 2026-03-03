import 'package:flutter/material.dart';

class AppConstants {
  static const List<String> categories = [
    'Casa',
    'Hotel',
    'Hostal',
    'Apartamento',
    'Restaurante',
    'Otro',
  ];

  static const List<String> alojCats = [
    'Casa',
    'Hotel',
    'Hostal',
    'Apartamento',
    'Restaurante',
    'Otro',
  ];

  static const Color primaryColor = Colors.teal;

  static const InputDecoration textFieldDecoration = InputDecoration(
    border: OutlineInputBorder(),
    labelStyle: TextStyle(color: Colors.teal),
  );
}
