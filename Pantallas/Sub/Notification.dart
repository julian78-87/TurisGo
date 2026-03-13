import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final colorFondo = const Color(0xFFF8FAFC);
  final colorCoral = const Color(0xFFFF6B6B);
  final colorCerceta = const Color(0xFF0D9488);
  final colorTexto = const Color(0xFF1E293B);

  Future<void> _handleReservation(String id, String newStatus) async {
    try {
      await Supabase.instance.client
          .from('reservations')
          .update({'status': newStatus})
          .eq('id', id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Reserva ${newStatus == 'confirmado' ? 'aceptada' : 'rechazada'}",
          ),
          backgroundColor: newStatus == 'confirmado'
              ? colorCerceta
              : colorCoral,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        title: const Text(
          'SOLICITUDES PENDIENTES',
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
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('reservations')
            .stream(primaryKey: ['id'])
            .eq('status', 'pendiente')
            .order('reservation_date'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: reservations.length,
            itemBuilder: (context, i) {
              return _buildNotificationItem(reservations[i]);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> res) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: colorTexto.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(15),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorCoral.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calendar_month_rounded, color: colorCoral),
            ),
            title: Text(
              "Nueva Solicitud de Reserva",
              style: TextStyle(fontWeight: FontWeight.bold, color: colorTexto),
            ),
            subtitle: Text(
              "Servicio: ${res['service_name'] ?? 'Cargando...'}\nFecha: ${res['reservation_date']}",
              style: TextStyle(
                color: colorTexto.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _handleReservation(res['id'], 'rechazado'),
                    style: TextButton.styleFrom(foregroundColor: colorCoral),
                    child: const Text("Rechazar"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _handleReservation(res['id'], 'confirmado'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorCerceta,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Aceptar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
