import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evv/Pantallas/Sub/Reserv_Details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';
  String selectedCategory = 'Todos';

  final categories = [
    'Todos',
    'Casa',
    'Hotel',
    'Hostal',
    'Apartamento',
    'Restaurante',
  ];

  final colorFondo = const Color(0xFF1A1A1A);
  final colorTarjeta = const Color(0xFF2D2D2D);
  final colorAcento = Colors.orangeAccent;
  final colorMarca = const Color(0xFF5F1E06);

  final Stream<List<Map<String, dynamic>>> _servicesStream = Supabase
      .instance
      .client
      .from('services')
      .stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'DESCUBRIR',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: colorTarjeta,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: TextField(
                onChanged: (v) => setState(() => searchQuery = v),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Busca tu próxima aventura...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: Icon(Icons.search_rounded, color: colorAcento),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? colorMarca : colorTarjeta,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? colorAcento : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? colorAcento : Colors.white70,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _servicesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Error al cargar datos",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(color: colorAcento),
                  );
                }

                final filteredServices = snapshot.data!.where((s) {
                  final nombre = (s['name'] ?? '').toString().toLowerCase();
                  final ubicacion = (s['address'] ?? '')
                      .toString()
                      .toLowerCase();
                  final categoria = (s['category'] ?? '').toString();

                  final matchQuery =
                      nombre.contains(searchQuery.toLowerCase()) ||
                      ubicacion.contains(searchQuery.toLowerCase());
                  final matchCategory =
                      selectedCategory == 'Todos' ||
                      categoria == selectedCategory;

                  return matchQuery && matchCategory;
                }).toList();

                if (filteredServices.isEmpty) {
                  return const Center(
                    child: Text(
                      "No se encontraron resultados",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  itemCount: filteredServices.length,
                  itemBuilder: (context, i) {
                    final s = filteredServices[i];
                    return _buildServiceCard(s);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: colorTarjeta,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
          tag: 'img-${s['id']}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              s['image_url'] ?? 'https://via.placeholder.com/150',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 80,
                height: 80,
                color: Colors.white10,
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.white24,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          s['name'] ?? 'Servicio sin nombre',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: colorAcento,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      s['address'] ?? 'Sin dirección',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '\$${s['price'] ?? 0}',
                style: TextStyle(
                  color: colorAcento,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        trailing: _buildRatingBadge(4.8),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailScreen(serviceData: s),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorMarca.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
          const SizedBox(width: 4),
          Text(
            '$rating',
            style: const TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
