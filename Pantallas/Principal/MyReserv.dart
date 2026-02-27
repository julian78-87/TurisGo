import 'package:evv/Componentes/General/Datos.dart';
import 'package:flutter/material.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({super.key});

  // Colores consistentes con el tema Ocean Night
  final colorFondo = const Color(0xFF0F172A);
  final colorTarjeta = const Color(0xFF1E293B);
  final colorAcento = const Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    if (AppData.myReservations.isEmpty) {
      return Container(
        color: colorFondo,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono decorativo para estado vacío
            Icon(
              Icons.calendar_today_outlined,
              size: 80,
              color: colorAcento.withOpacity(0.2),
            ),
            const SizedBox(height: 20),
            const Text(
              'Aún no tienes reservas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Tus próximas aventuras\naparecerán aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorFondo,
        title: const Text(
          'MIS VIAJES',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: AppData.myReservations.length,
        itemBuilder: (context, i) {
          final r = AppData.myReservations[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: colorTarjeta,
              borderRadius: BorderRadius.circular(25),
              // Sutil borde lateral para dar color de "estado confirmado"
              border: Border(left: BorderSide(color: colorAcento, width: 5)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Imagen miniatura estilizada
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      r.service.imagen,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Información de la reserva
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.service.nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.date_range,
                              size: 14,
                              color: Colors.white38,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${r.fechaInicio.day}/${r.fechaInicio.month} - ${r.fechaFin.day}/${r.fechaFin.month}',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Badge de "Confirmado"
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorAcento.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'CONFIRMADO',
                            style: TextStyle(
                              color: colorAcento,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Precio total destacado
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(color: Colors.white24, fontSize: 10),
                      ),
                      Text(
                        '\$${r.total.toInt()}',
                        style: TextStyle(
                          color: colorAcento,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
