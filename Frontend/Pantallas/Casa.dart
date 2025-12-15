import 'package:evv/Pantallas/Ingreso.dart';
import 'package:flutter/material.dart';
import 'package:evv/Servicios/Servicios.dart';

class HomeScreen extends StatelessWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.all[email]!;

    return Scaffold(
      appBar: AppBar(title: const Text("Inicio")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Bienvenido, ${user['nombre']}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(email),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Cerrar sesión"),
              onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
