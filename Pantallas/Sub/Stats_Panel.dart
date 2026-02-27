import 'package:evv/Componentes/General/Datos.dart';
import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  // --- PALETA CORAL REEF ---
  final colorFondo = const Color(0xFFF8FAFC); // Perla
  final colorCoral = const Color(0xFFFF6B6B); // Coral
  final colorCerceta = const Color(0xFF0D9488); // Cerceta
  final colorTexto = const Color(0xFF1E293B); // Azul Abismo

  @override
  Widget build(BuildContext context) {
    final totalReservas = AppData.myReservations.length + 47;
    final ingresos = 12480000.0;

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        title: const Text(
          'DASHBOARD',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        backgroundColor: colorFondo,
        foregroundColor: colorTexto,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas Generales',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorTexto,
              ),
            ),
            const SizedBox(height: 20),

            // FILA DE TARJETAS DE ESTADÍSTICAS
            Row(
              children: [
                _statCard(
                  'Reservas',
                  '$totalReservas',
                  colorCoral,
                  Icons.kayaking_rounded,
                ),
                const SizedBox(width: 16),
                _statCard(
                  'Ingresos',
                  '\$${ingresos.toInt()}',
                  colorCerceta,
                  Icons.payments_rounded,
                ),
              ],
            ),

            const SizedBox(height: 35),

            // SECCIÓN DE SERVICIOS TOP
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Servicios Destacados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorTexto,
                  ),
                ),
                Icon(Icons.trending_up_rounded, color: colorCerceta),
              ],
            ),
            const SizedBox(height: 15),

            ...AppData.services.take(3).map((s) => _buildServiceTile(s)),

            const SizedBox(height: 40),

            // SECCIÓN DE REPORTES
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: colorTexto.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colorCerceta.withOpacity(0.1),
                        child: Icon(
                          Icons.description_rounded,
                          color: colorCerceta,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        'Reporte Mensual PDF',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _showReportDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorTexto,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text('GENERAR Y DESCARGAR'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 15),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: colorTexto,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: colorTexto.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTile(dynamic s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            s.imagen,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          s.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          '${s.reviews} reservas realizadas',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${s.rating} ★',
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reporte Generado'),
        content: const Text(
          'El análisis de rendimiento está listo para su descarga.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ENTENDIDO',
              style: TextStyle(
                color: colorCerceta,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
