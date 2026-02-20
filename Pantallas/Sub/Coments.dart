import 'package:evv/Main.dart';
import 'package:flutter/material.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int selectedStars = 0;
  final TextEditingController commentController = TextEditingController();

  Future<void> _submit() async {
    if (selectedStars == 0 || commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debes seleccionar estrellas y escribir un comentario"),
        ),
      );
      return;
    }

    try {
      await supabase.from('ratings').insert({
        'user_name': 'Usuario',
        'rating': selectedStars,
        'comment': commentController.text.trim(),
      });

      commentController.clear();
      setState(() {
        selectedStars = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comentario enviado correctamente")),
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
      backgroundColor: const Color(0xFFECE6F0),
      body: Row(
        children: [
          /// PANEL IZQUIERDO - PROMEDIO EN TIEMPO REAL
          Expanded(
            flex: 2,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase.from('ratings').stream(primaryKey: ['id']),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final ratings = snapshot.data!;
                double avg = 0;

                if (ratings.isNotEmpty) {
                  avg =
                      ratings
                          .map((r) => r['rating'] as int)
                          .reduce((a, b) => a + b) /
                      ratings.length;
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        avg.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < avg.round() ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Basado en ${ratings.length} opiniones"),
                    ],
                  ),
                );
              },
            ),
          ),

          /// PANEL DERECHO
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Deja una Calificación",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: List.generate(
                      5,
                      (i) => IconButton(
                        icon: Icon(
                          i < selectedStars ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedStars = i + 1;
                          });
                        },
                      ),
                    ),
                  ),

                  TextField(
                    controller: commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Escribe tu comentario...",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text("Enviar"),
                  ),

                  const Divider(height: 40),

                  const Text(
                    "Comentarios",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: supabase
                          .from('ratings')
                          .stream(primaryKey: ['id'])
                          .order('created_at', ascending: false),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final ratings = snapshot.data!;

                        return ListView.builder(
                          itemCount: ratings.length,
                          itemBuilder: (context, index) {
                            final r = ratings[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Row(
                                  children: [
                                    Text(r['user_name'] ?? ''),
                                    const SizedBox(width: 8),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (j) => Icon(
                                          j < r['rating']
                                              ? Icons.star
                                              : Icons.star_border,
                                          size: 16,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Text(r['comment'] ?? ''),
                              ),
                            );
                          },
                        );
                      },
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
