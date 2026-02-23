import 'package:evv/Componentes/General/Datos.dart';
import 'package:flutter/material.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppData.myReservations.isEmpty) {
      return const Center(
        child: Text(
          'Aún no tienes reservas\n¡Explora y reserva!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: AppData.myReservations.length,
      itemBuilder: (context, i) {
        final r = AppData.myReservations[i];
        return Card(
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                r.service.imagen,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(r.service.nombre),
            subtitle: Text(
              '${r.fechaInicio.day}/${r.fechaInicio.month} - ${r.fechaFin.day}/${r.fechaFin.month}',
            ),
            trailing: Text(
              '\$${r.total.toInt()}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
