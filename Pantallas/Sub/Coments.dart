import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Main.dart';
import 'package:flutter/material.dart';

class RatingPage extends StatefulWidget {
  final String serviceId;
  const RatingPage({super.key, required this.serviceId});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int selectedStars = 0;
  final TextEditingController commentController = TextEditingController();

  // --- PALETA CORAL REEF ---
  final colorFondo = const Color(0xFFF8FAFC);
  final colorCoral = const Color(0xFFFF6B6B);
  final colorCerceta = const Color(0xFF0D9488);
  final colorTexto = const Color(0xFF1E293B);

  Future<void> _submit() async {
    if (selectedStars == 0 || commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Selecciona estrellas y escribe algo"),
          backgroundColor: colorCoral,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      await supabase.from('ratings').insert({
        'service_id': widget.serviceId,
        'user_name': AppData.currentUser['nombre'],
        'rating': selectedStars,
        'comment': commentController.text.trim(),
      });

      commentController.clear();
      setState(() => selectedStars = 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("¡Gracias por tu opinión!"),
          backgroundColor: colorCerceta,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        title: const Text(
          "OPINIONES",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
        backgroundColor: colorFondo,
        foregroundColor: colorTexto,
        elevation: 0,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          // CABECERA - PROMEDIO
          SliverToBoxAdapter(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('ratings')
                  .stream(primaryKey: ['id'])
                  .eq('service_id', widget.serviceId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LinearProgressIndicator();
                final ratings = snapshot.data!;
                double avg = ratings.isEmpty
                    ? 0
                    : ratings
                              .map((r) => r['rating'] as int)
                              .reduce((a, b) => a + b) /
                          ratings.length;

                return Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: colorTexto.withOpacity(0.05),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        avg.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w900,
                          color: colorTexto,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < avg.round()
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Basado en ${ratings.length} experiencias",
                        style: TextStyle(color: colorTexto.withOpacity(0.5)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // SECCIÓN PARA CALIFICAR
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tu calificación",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(
                      5,
                      (i) => IconButton(
                        icon: Icon(
                          i < selectedStars
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: colorCoral,
                          size: 35,
                        ),
                        onPressed: () => setState(() => selectedStars = i + 1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Cuéntanos tu experiencia...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorCerceta,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "PUBLICAR COMENTARIO",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Comunidad",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),

          // LISTA DE COMENTARIOS
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: supabase
                .from('ratings')
                .stream(primaryKey: ['id'])
                .eq('service_id', widget.serviceId),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const SliverToBoxAdapter(child: SizedBox());
              final ratings = snapshot.data!;
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final r = ratings[index];
                  return Container(
                    margin: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      bottom: 15,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorTexto.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: colorCoral.withOpacity(0.1),
                              child: Text(
                                r['user_name'][0].toUpperCase(),
                                style: TextStyle(
                                  color: colorCoral,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r['user_name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (j) => Icon(
                                      j < r['rating']
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      size: 14,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          r['comment'],
                          style: TextStyle(
                            color: colorTexto.withOpacity(0.8),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                }, childCount: ratings.length),
              );
            },
          ),
        ],
      ),
    );
  }
}
