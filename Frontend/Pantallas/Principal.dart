import 'package:flutter/material.dart';
import 'package:evv/Componentes/Principal/Barra.dart';

class Principal extends StatelessWidget {
  const Principal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrincipalAppBar(),
      body: const Center(
        child: Text(
          'Bienvenido a turisgo',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
