import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Componentes/General/Principal.dart';
import 'package:evv/Pantallas/Sub/Coments.dart';
import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatefulWidget {
  final TouristService service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

  // --- PALETA CORAL REEF ---
  final colorFondo = const Color(0xFFF8FAFC); // Perla
  final colorCoral = const Color(0xFFFF6B6B); // Coral Vibrante
  final colorCerceta = const Color(0xFF0D9488); // Cerceta Profundo
  final colorTexto = const Color(0xFF1E293B); // Azul Abismo

  void _book() {
    final res = Reservation(
      id: 'R${DateTime.now().millisecondsSinceEpoch}',
      service: widget.service,
      fechaInicio: selectedDate,
      fechaFin: selectedDate.add(const Duration(days: 3)),
      personas: 2,
      total: widget.service.precio * 3,
      estado: 'Confirmada',
    );
    AppData.myReservations.add(res);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '¡Aventura reservada!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: colorCerceta,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      body: CustomScrollView(
        slivers: [
          // APP BAR CON IMAGEN PROTAGONISTA
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(widget.service.imagen, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [Colors.black54, Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÍTULO Y PRECIO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.service.nombre,
                          style: TextStyle(
                            color: colorTexto,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        '\$${widget.service.precio.toInt()}',
                        style: TextStyle(
                          color: colorCerceta,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // UBICACIÓN ESTILIZADA
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: colorCoral,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.service.ubicacion,
                        style: TextStyle(
                          color: colorTexto.withOpacity(0.6),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // CARD DE RATING "CORAL REEF"
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RatingPage(serviceId: widget.service.id),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: colorTexto.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: colorCoral.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.service.rating}',
                                  style: TextStyle(
                                    color: colorTexto,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            '${widget.service.reviews} opiniones de viajeros',
                            style: TextStyle(
                              color: colorTexto.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colorTexto.withOpacity(0.3),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Text(
                    'Descripción',
                    style: TextStyle(
                      color: colorTexto,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.service.descripcion,
                    style: TextStyle(
                      color: colorTexto.withOpacity(0.7),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // BOTÓN DE ACCIÓN CORAL
                  ElevatedButton(
                    onPressed: _book,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorCoral,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'CONFIRMAR RESERVA',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
