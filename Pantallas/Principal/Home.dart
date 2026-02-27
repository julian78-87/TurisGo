import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Componentes/General/Principal.dart';
import 'package:evv/Pantallas/Sub/Reserv_Details.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Definición de colores para fácil mantenimiento
    const colorFondo = Color(0xFF0F172A);
    const colorTarjeta = Color(0xFF1E293B);
    const colorAcento = Color(0xFF10B981); // Verde esmeralda vibrante

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorFondo,
        title: const Text(
          'EXPLORA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: colorAcento.withOpacity(0.2),
              child: IconButton(
                icon: const Icon(
                  Icons.map_rounded,
                  color: colorAcento,
                  size: 20,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InteractiveMapScreen(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARRUSEL CON EFECTO DE ESCALA
            SizedBox(
              height: 260,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                itemCount: 5,
                itemBuilder: (context, i) {
                  final service = AppData.services[i % AppData.services.length];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(service.imagen, fit: BoxFit.cover),
                          // Overlay degradado más dramático
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorAcento,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "DESTACADO",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  service.nombre,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                'Destinos Populares',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // LISTA DE DESTINOS (Cards Dark)
            SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 24),
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
                      margin: const EdgeInsets.only(right: 16, bottom: 10),
                      decoration: BoxDecoration(
                        color: colorTarjeta,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              s.imagen,
                              height: 140,
                              width: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.nombre,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${s.precio.toInt()}',
                                  style: const TextStyle(
                                    color: colorAcento,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // NOTIFICACIONES (Estilo Glassmorphism ligero)
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
              child: Text(
                'Actividad Reciente',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ...AppData.notifications
                .take(3)
                .map(
                  (n) => Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.circle,
                        color: colorAcento,
                        size: 12,
                      ),
                      title: Text(
                        n.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        n.body,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      trailing: Text(
                        '${n.time.hour}:${n.time.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          color: Colors.white24,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
