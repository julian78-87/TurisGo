import 'package:evv/Pantallas/Ingreso.dart';
import 'package:evv/Pantallas/Principal.dart';
import 'package:evv/Pantallas/Registro.dart';
import 'package:evv/Pantallas/ingreso_servicios_turisticos.dart';
import 'package:flutter/material.dart';

class Conexion extends StatelessWidge {
  const Conexion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Principal(),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/create_accommodation': (context) => const HomePage(),
      },
    );
  }
}
