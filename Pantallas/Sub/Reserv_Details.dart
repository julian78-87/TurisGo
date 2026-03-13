import 'package:evv/Componentes/MyService/BookingPanel.dart';
import 'package:evv/Componentes/MyService/RatingBadge.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> serviceData;
  const ServiceDetailScreen({super.key, required this.serviceData});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final colorFondo = const Color(0xFFF8FAFC);
  final colorCoral = const Color(0xFFFF6B6B);
  final colorCerceta = const Color(0xFF0D9488);
  final colorTexto = const Color(0xFF1E293B);

  bool _isBooking = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  int _personCount = 1;

  double get _totalPrice =>
      (widget.serviceData['price'] ?? 0).toDouble() * _personCount;
  Future<void> _book() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, inicia sesión para reservar')),
      );
      return;
    }

    setState(() => _isBooking = true);
    try {
      final s = widget.serviceData;
      await Supabase.instance.client.from('reservations').insert({
        'user_id': user.id,
        'service_id': s['id'],
        'service_name': s['name'],
        'service_image': s['image_url'],
        'price': _totalPrice,
        'status': 'pendiente',
        'reservation_date': _selectedDate.toIso8601String(),
        'guests': _personCount,
      });

      if (!mounted) return;
      _showSuccessDialog(s['name'] ?? 'Servicio');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  Widget _buildAppBar(Map s) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          s['image_url'] ?? 'https://via.placeholder.com/400',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildHeader(Map s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                s['name'] ?? 'Sin nombre',
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Text(
              '\$${s['price'] ?? 0}',
              style: TextStyle(
                color: colorCerceta,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          s['address'] ?? 'Ubicación no disponible',
          style: TextStyle(color: colorTexto.withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _buildDescription(Map s) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descripción',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          s['description'] ?? 'No hay descripción disponible.',
          style: TextStyle(color: colorTexto.withOpacity(0.7), height: 1.6),
        ),
      ],
    );
  }

  Widget _buildPriceAndButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total estimado',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              '\$${_totalPrice.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: colorTexto,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isBooking ? null : _book,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorCoral,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: _isBooking
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'CONFIRMAR RESERVA',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.serviceData;
    return Scaffold(
      backgroundColor: colorFondo,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(s),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(s),
                  const SizedBox(height: 25),
                  RatingBadge(serviceId: s['id'], textColor: colorTexto),
                  const SizedBox(height: 30),
                  _buildDescription(s),
                  const SizedBox(height: 30),
                  BookingPanel(
                    selectedDate: _selectedDate,
                    personCount: _personCount,
                    themeColor: colorCerceta,
                    onSelectDate: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null)
                        setState(() => _selectedDate = picked);
                    },
                    onAddPerson: () => setState(() => _personCount++),
                    onRemovePerson: () {
                      if (_personCount > 1) setState(() => _personCount--);
                    },
                  ),
                  const SizedBox(height: 30),
                  _buildPriceAndButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String nombre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            Text(
              "¡Reserva confirmada!",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Tu visita a $nombre ha sido registrada.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: colorCerceta),
              child: const Text(
                "Entendido",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
