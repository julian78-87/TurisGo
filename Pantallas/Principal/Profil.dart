import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evv/Pantallas/Principal/Login_Register.dart';
import 'package:evv/Pantallas/Sub/Notification.dart';
import 'package:evv/Pantallas/Sub/Stats_Panel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Colores del tema Ocean Night
  final colorFondo = const Color(0xFF0F172A);
  final colorTarjeta = const Color(0xFF1E293B);
  final colorAcento = const Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final userAuth = supabase.auth.currentUser;

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorFondo,
        title: const Text(
          'PERFIL',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('profiles')
            .stream(primaryKey: ['id'])
            .eq('id', userAuth?.id ?? '')
            .handleError((error) => print("ERROR: $error")),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: colorAcento));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "Perfil no encontrado",
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          final profileData = snapshot.data!.first;
          final String fullName = profileData['full_name'] ?? 'Usuario';
          final String role = profileData['role'] ?? 'usuario';
          final String? avatarUrl = profileData['avatar_url'];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                // SECCIÓN DE ENCABEZADO (AVATAR)
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [colorAcento, Colors.blueAccent],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: colorTarjeta,
                        backgroundImage: avatarUrl != null
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: avatarUrl == null
                            ? Icon(Icons.person, size: 60, color: colorAcento)
                            : null,
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: colorAcento,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userAuth?.email ?? '',
                  style: const TextStyle(color: Colors.white38, fontSize: 14),
                ),
                const SizedBox(height: 15),
                // Badge de Rol
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorAcento.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorAcento.withOpacity(0.5)),
                  ),
                  child: Text(
                    role.toUpperCase(),
                    style: TextStyle(
                      color: colorAcento,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // OPCIONES DE PERFIL (Encapsuladas en una tarjeta)
                Container(
                  decoration: BoxDecoration(
                    color: colorTarjeta,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      _buildProfileOption(
                        Icons.star_outline_rounded,
                        'Mis calificaciones',
                        () {},
                      ),
                      const Divider(color: Colors.white10, height: 1),
                      _buildProfileOption(
                        Icons.bookmark_border_rounded,
                        'Mis reservas',
                        () {},
                      ),
                      const Divider(color: Colors.white10, height: 1),
                      _buildProfileOption(
                        Icons.notifications_none_rounded,
                        'Notificaciones',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        ),
                      ),
                      if (role == 'admin') ...[
                        const Divider(color: Colors.white10, height: 1),
                        _buildProfileOption(
                          Icons.analytics_outlined,
                          'Panel de Estadísticas',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminPanelScreen(),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // BOTÓN CERRAR SESIÓN
                TextButton.icon(
                  onPressed: () async {
                    await supabase.auth.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: Colors.redAccent,
                  ),
                  label: const Text(
                    'Cerrar Sesión Segura',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: colorAcento, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white24,
        size: 16,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
  }
}
