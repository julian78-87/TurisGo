import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Componentes/General/Principal.dart';
import 'package:evv/Pantallas/Sub/Reserv_Details.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explora Turismo'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InteractiveMapScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARRUSEL
            SizedBox(
              height: 240,
              child: PageView.builder(
                itemCount: 5,
                itemBuilder: (context, i) {
                  final service = AppData.services[i % AppData.services.length];
                  return Stack(
                    children: [
                      Image.network(
                        service.imagen,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 240,
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Text(
                          service.nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(blurRadius: 8)],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Destinos populares',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: AppData.services.length,
                itemBuilder: (context, index) {
                  final s = AppData.services[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceDetailScreen(service: s),
                      ),
                    ),
                    child: Container(
                      width: 160,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              s.imagen,
                              height: 140,
                              width: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            s.nombre,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '\$${s.precio.toInt()}',
                            style: const TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Notificaciones recientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            ...AppData.notifications
                .take(3)
                .map(
                  (n) => ListTile(
                    leading: const Icon(
                      Icons.notifications_active,
                      color: Colors.orange,
                    ),
                    title: Text(n.title),
                    subtitle: Text(n.body),
                    trailing: Text(
                      '${n.time.hour}:${n.time.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
