import 'package:flutter/material.dart';
import 'package:evv/Servicios/servicios.dart';
import 'package:evv/Componentes/ingreso/Style_I.dart';
import 'package:evv/Componentes/ingreso/Custom_I.dart';
import 'package:evv/Componentes/ingreso/White_B.dart';
import 'Recuperar_contraseña.dart';
import 'Registro.dart';
import 'Casa.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final cCorreo = TextEditingController();
  final cPass = TextEditingController();

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(email: cCorreo.text.trim().toLowerCase()),
      ),
    );
  }

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInput(label: "Correo", controller: cCorreo),
                const SizedBox(height: 16),

                CustomInput(
                  label: "Contraseña",
                  controller: cPass,
                  obscure: true,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ButtonStyles.primary(),
                  onPressed: () {
                    final r = AuthService.instance.login(
                      cCorreo.text,
                      cPass.text,
                    );

                    if (r == "OK") {
                      _goHome();
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(r)));
                    }
                  },
                  child: const Text("Ingresar"),
                ),

                const SizedBox(height: 20),

                WhiteButton(
                  text: "Crear cuenta",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                ),

                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResetScreen()),
                  ),
                  child: const Text(
                    "¿Olvidaste tu contraseña?",
                    style: TextStyle(
                      color: Colors.purple,
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
