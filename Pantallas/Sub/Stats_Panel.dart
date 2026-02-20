import 'package:evv/Componentes/General/Datos.dart';
import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalReservas = AppData.myReservations.length + 47;
    final ingresos = 12480000.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Administración')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas Generales',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _statCard('Reservas Totales', '$totalReservas', Colors.blue),
                const SizedBox(width: 12),
                _statCard('Ingresos', '\$${ingresos.toInt()}', Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Servicios más reservados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            ...AppData.services
                .take(3)
                .map(
                  (s) => ListTile(
                    title: Text(s.nombre),
                    subtitle: Text('${s.reviews} reservas'),
                    trailing: Text('${s.rating} ★'),
                  ),
                ),
            const SizedBox(height: 30),
            const Text(
              'Reportes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Reporte PDF'),
                  content: const Text(
                    'Reporte generado correctamente (simulado)',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              child: const Text('Generar Reporte Completo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 14)),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
