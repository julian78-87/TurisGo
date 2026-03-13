import 'package:evv/Main.dart';
import 'package:evv/Pantallas/Sub/Coments.dart';
import 'package:flutter/material.dart';

class MyCommentsScreen extends StatelessWidget {
  const MyCommentsScreen({super.key});

  final colorFondo = const Color(0xFFF8FAFC);
  final colorCerceta = const Color(0xFF0D9488);
  final colorTexto = const Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Gestionar Reseñas",
          style: TextStyle(color: colorTexto, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: colorTexto),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // Escuchamos los servicios
        stream: supabase.from('services').stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error al cargar"));
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final services = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return _ServiceCommentCard(
                service: service,
                colorCerceta: colorCerceta,
              );
            },
          );
        },
      ),
    );
  }
}

class _ServiceCommentCard extends StatelessWidget {
  final Map<String, dynamic> service;
  final Color colorCerceta;

  const _ServiceCommentCard({
    required this.service,
    required this.colorCerceta,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RatingPage(serviceId: service['id'].toString()),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  service['image_url'] ?? 'https://via.placeholder.com/400',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        size: 14,
                        color: colorCerceta,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Ver comentarios",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
