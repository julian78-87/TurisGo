import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Pantallas/Principal.dart';
import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatefulWidget {
  final TouristService service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  int _rating = 5;
  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

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
      const SnackBar(
        content: Text('¡Reserva confirmada!'),
        backgroundColor: Colors.teal,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.service.imagen,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.service.nombre,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.teal),
                      Text(
                        widget.service.ubicacion,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '${widget.service.rating}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.star, color: Colors.amber),
                      Text(' (${widget.service.reviews} opiniones)'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.service.descripcion,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Califica este servicio',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (i) => IconButton(
                        icon: Icon(
                          Icons.star,
                          color: i < _rating ? Colors.amber : Colors.grey,
                          size: 40,
                        ),
                        onPressed: () => setState(() => _rating = i + 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _book,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: Colors.teal,
                    ),
                    child: Text(
                      'Reservar ahora - \$ ${widget.service.precio.toInt()} por noche',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
