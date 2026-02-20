import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Pantallas/Login_Register.dart';
import 'package:evv/Pantallas/Notification.dart';
import 'package:evv/Pantallas/Stats_Panel.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AppData.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user['foto']),
            ),
            const SizedBox(height: 16),
            Text(
              user['nombre'],
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(user['email']),
            const SizedBox(height: 30),
            _buildProfileOption(Icons.star, 'Mis calificaciones', () {}),
            _buildProfileOption(Icons.book, 'Mis reservas', () {}),
            _buildProfileOption(
              Icons.notifications,
              'Notificaciones',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
            ),
            if (user['isAdmin'] == true)
              _buildProfileOption(
                Icons.admin_panel_settings,
                'Reporte de estadisticas',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
                ),
              ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
