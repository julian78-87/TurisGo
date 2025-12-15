import 'package:flutter/material.dart';
import 'package:evv/Componentes/Principal/Botones.dart';
import 'package:evv/Pantallas/Ingreso.dart';
import 'package:evv/Pantallas/Registro.dart';
import 'package:evv/Pantallas/ingreso_servicios_turisticos.dart';

class PrincipalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrincipalAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'turisgo',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
      actions: [
        Wrap(
          children: [
            AppBarButton(
              label: 'Ingreso',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegando a Ingreso')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
            AppBarButton(
              label: 'Registro',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegando a Registro')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
            ),
            AppBarButton(
              label: 'Crear alojamiento',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navegando a Crear Alojamiento'),
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
