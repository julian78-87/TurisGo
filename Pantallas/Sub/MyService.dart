import 'package:evv/Pantallas/Sub/AddService.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyServicesScreen extends StatelessWidget {
  const MyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    const colorFondo = Color(0xFFF8FAFC); // Perla
    const colorCoral = Color(0xFFFF6B6B); // Coral (Acciones/Eliminar)
    const colorCerceta = Color(0xFF0D9488); // Cerceta (Precio/Acentos)
    const colorTexto = Color(0xFF1E293B); // Azul Abismo (Títulos)

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorFondo,
        foregroundColor: colorTexto,
        title: const Text(
          'MIS SERVICIOS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('services')
            .stream(primaryKey: ['id'])
            .eq('user_id', user?.id ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: colorCerceta),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: colorTexto.withOpacity(0.1),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No has creado ningún servicio aún.",
                    style: TextStyle(
                      color: colorTexto.withOpacity(0.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          final services = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final item = services[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colorTexto.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.all(12),
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: colorTexto.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item['image_url'] ??
                                'https://via.placeholder.com/150',
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        item['name'] ?? 'Sin nombre',
                        style: const TextStyle(
                          color: colorTexto,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "\$${item['price']}",
                          style: const TextStyle(
                            color: colorCerceta,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: colorFondo.withOpacity(0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                icon: Icons.edit_note_rounded,
                                label: "Editar",
                                color: Colors.blueGrey,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AddServiceScreen(serviceToEdit: item),
                                    ),
                                  );
                                },
                              ),
                              _buildActionButton(
                                icon: Icons.delete_outline_rounded,
                                label: "Eliminar",
                                color: colorCoral,
                                onTap: () =>
                                    _confirmDelete(context, item['id']),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 20),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic serviceId) {
    const colorCoral = Color(0xFFFF6B6B);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "¿Eliminar servicio?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Esta acción quitará el servicio de la vista pública de TurisGo.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorCoral,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              await Supabase.instance.client
                  .from('services')
                  .delete()
                  .eq('id', serviceId);
              Navigator.pop(context);
            },
            child: const Text(
              "SÍ, ELIMINAR",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
