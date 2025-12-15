import 'package:flutter/material.dart';
import 'package:evv/Servicios/Servicios.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});

  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final cCorreo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recuperar contraseña")),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cCorreo,
              decoration: const InputDecoration(labelText: "Correo"),
            ),
            ElevatedButton(
              child: const Text("Enviar token"),
              onPressed: () {
                final r = AuthService.instance.reset(cCorreo.text);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(r)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
