import 'package:evv/Componentes/General/Datos.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // --- PALETA CORAL REEF ---
  final colorFondo = const Color(0xFFF8FAFC);
  final colorCoral = const Color(0xFFFF6B6B);
  final colorCerceta = const Color(0xFF0D9488);
  final colorTexto = const Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        title: const Text(
          'NOTIFICACIONES',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            fontSize: 16,
          ),
        ),
        backgroundColor: colorFondo,
        foregroundColor: colorTexto,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.done_all_rounded, color: colorCerceta),
            onPressed: () {
              setState(() {
                for (var n in AppData.notifications) {
                  n.read = true;
                }
              });
            },
          ),
        ],
      ),
      body: AppData.notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: AppData.notifications.length,
              itemBuilder: (context, i) {
                final n = AppData.notifications[i];
                return _buildNotificationItem(n, i);
              },
            ),
    );
  }

  Widget _buildNotificationItem(dynamic n, int i) {
    return Dismissible(
      key: Key(n.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: colorCoral.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_sweep_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      onDismissed: (_) {
        setState(() => AppData.notifications.removeAt(i));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Notificación eliminada"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: n.read ? Colors.white.withOpacity(0.6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: n.read ? Colors.transparent : colorCoral.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: colorTexto.withOpacity(n.read ? 0.02 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: n.read
                  ? colorTexto.withOpacity(0.05)
                  : colorCoral.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              n.read
                  ? Icons.notifications_none_rounded
                  : Icons.notifications_active_rounded,
              color: n.read ? colorTexto.withOpacity(0.3) : colorCoral,
            ),
          ),
          title: Text(
            n.title,
            style: TextStyle(
              fontWeight: n.read ? FontWeight.normal : FontWeight.bold,
              color: n.read ? colorTexto.withOpacity(0.6) : colorTexto,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              n.body,
              style: TextStyle(
                color: colorTexto.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${n.time.hour.toString().padLeft(2, '0')}:${n.time.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: colorTexto.withOpacity(0.3),
                ),
              ),
              if (!n.read)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorCoral,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          onTap: () => setState(() => n.read = true),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 80,
            color: colorTexto.withOpacity(0.1),
          ),
          const SizedBox(height: 20),
          Text(
            "¡Todo al día!",
            style: TextStyle(
              color: colorTexto.withOpacity(0.3),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
