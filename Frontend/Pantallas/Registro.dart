import 'package:flutter/material.dart';
import 'package:evv/Servicios/Servicios.dart';
import 'package:evv/Componentes/Ingreso/Custom_I.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final cNombre = TextEditingController();
  final cCorreo = TextEditingController();
  final cPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF1B263B), Color(0xFFE0E5EC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Crear cuenta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 26),

                CustomInput(label: "Nombre", controller: cNombre),
                const SizedBox(height: 16),

                CustomInput(label: "Correo", controller: cCorreo),
                const SizedBox(height: 16),

                CustomInput(
                  label: "Contraseña",
                  controller: cPass,
                  obscure: true,
                ),

                const SizedBox(height: 26),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _registrar,
                  child: const Text("Registrar"),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Volver al inicio",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registrar() {
    final r = AuthService.instance.register(
      cNombre.text,
      cCorreo.text,
      cPass.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(r)));

    if (r == "OK") Navigator.pop(context);
  }
}
