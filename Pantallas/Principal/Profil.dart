import 'package:evv/Pantallas/Principal/initial.dart';
import 'package:evv/Pantallas/Sub/AdminPanel.dart';
import 'package:evv/Pantallas/Sub/MyComents.dart';
import 'package:evv/Pantallas/Sub/MyService.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evv/Pantallas/Sub/Notification.dart';
import 'package:evv/Pantallas/Sub/Stats_Panel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final Color colorFondo = const Color(0xFF1A1A1A);
  final Color colorTarjeta = const Color(0xFF2D2D2D);
  final Color colorAcento = Colors.orangeAccent;
  final Color colorMarca = const Color(0xFF5F1E06);

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
            letterSpacing: 3,
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
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorAcento),
              ),
            );
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
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [colorMarca, colorAcento],
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
                        color: Color(0xFF5F1E06),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorMarca.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorAcento.withOpacity(0.4)),
                  ),
                  child: Text(
                    role.toUpperCase(),
                    style: TextStyle(
                      color: colorAcento,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Container(
                  decoration: BoxDecoration(
                    color: colorTarjeta,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      _buildProfileOption(
                        Icons.star_outline_rounded,
                        'Mis calificaciones',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyCommentsScreen(),
                          ),
                        ),
                      ),
                      const Divider(color: Colors.white10, height: 1),
                      _buildProfileOption(
                        Icons.bookmark_border_rounded,
                        'Mis reservas',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyServicesScreen(),
                          ),
                        ),
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
                      const Divider(color: Colors.white10, height: 1),
                      _buildProfileOption(
                        Icons.analytics_outlined,
                        'Panel de Estadísticas',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const StadsPanel()),
                        ),
                      ),
                      if (role == 'admin') ...[
                        const Divider(color: Colors.white10, height: 1),
                        _buildProfileOption(
                          Icons.admin_panel_settings_outlined,
                          'Panel de Admin',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AdminPanelPage(),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                TextButton.icon(
                  onPressed: () async {
                    await supabase.auth.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const intial()),
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
                    backgroundColor: Colors.redAccent.withOpacity(0.1),
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
        size: 14,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
  }
}
