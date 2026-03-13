import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyReservationsPage extends StatelessWidget {
  const MyReservationsPage({super.key});

  final Color colorFondo = const Color(0xFF1A1A1A);
  final Color colorTarjeta = const Color(0xFF2D2D2D);
  final Color colorAcento = const Color(0xFFFF9800);
  final Color colorMarca = const Color(0xFF5F1E06);

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return _buildEmptyState();

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'MIS VIAJES',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: Supabase.instance.client
            .from('reservations')
            .stream(primaryKey: ['id'])
            .eq('user_id', user.id)
            .order('reservation_date'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: colorAcento));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final reservations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            itemCount: reservations.length,
            itemBuilder: (context, i) {
              return _ReservationCard(
                res: reservations[i],
                colorTarjeta: colorTarjeta,
                colorAcento: colorAcento,
                colorMarca: colorMarca,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: colorFondo,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.luggage_outlined,
            size: 80,
            color: colorAcento.withOpacity(0.5),
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
        ],
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Map<String, dynamic> res;
  final Color colorTarjeta;
  final Color colorAcento;
  final Color colorMarca;

  const _ReservationCard({
    required this.res,
    required this.colorTarjeta,
    required this.colorAcento,
    required this.colorMarca,
  });

  Widget build(BuildContext context) {
    final String status = res['status'] ?? 'pendiente';
    Color statusColor = status == 'confirmado'
        ? Colors.greenAccent
        : (status == 'rechazado' ? Colors.redAccent : Colors.orangeAccent);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: colorTarjeta,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(width: 6, color: statusColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildIconBox(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Reserva #${res['id'].toString().toUpperCase().substring(0, 6)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow
                                .ellipsis, // Si es muy largo, pone "..."
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.circle, size: 8, color: statusColor),
                              const SizedBox(width: 6),
                              Text(
                                status.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildDestinationInfo(res['reservation_date']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorMarca.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        Icons.confirmation_num_outlined,
        color: colorAcento,
        size: 28,
      ),
    );
  }

  Widget _buildDestinationInfo(dynamic date) {
    String cleanDate = date.toString().split('T')[0];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "FECHA",
          style: TextStyle(color: Colors.white38, fontSize: 9),
        ),
        Text(
          cleanDate,
          style: TextStyle(
            color: colorAcento,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
