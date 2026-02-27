import 'package:evv/Componentes/General/Datos.dart';
import 'package:evv/Componentes/General/Principal.dart';
import 'package:evv/Pantallas/Sub/Reserv_Details.dart';
import 'package:flutter/material.dart';

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

  // Colores del tema "Ocean Night"
  final colorFondo = const Color(0xFF0F172A);
  final colorTarjeta = const Color(0xFF1E293B);
  final colorAcento = const Color(0xFF10B981);

  List<TouristService> get filteredServices {
    return AppData.services.where((s) {
      final matchQuery =
          s.nombre.toLowerCase().contains(searchQuery.toLowerCase()) ||
          s.ubicacion.toLowerCase().contains(searchQuery.toLowerCase());
      final matchCategory =
          selectedCategory == 'Todos' || s.categoria == selectedCategory;
      return matchQuery && matchCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorFondo,
        title: const Text(
          'DESCUBRIR',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // BARRA DE BÚSQUEDA ESTILIZADA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: colorTarjeta,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
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

          // FILTROS DE CATEGORÍA (Chips Personalizados)
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
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? colorAcento : colorTarjeta,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? colorAcento : Colors.white10,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? colorFondo : Colors.white70,
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

          // LISTADO DE RESULTADOS
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: filteredServices.length,
              itemBuilder: (context, i) {
                final s = filteredServices[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: colorTarjeta,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Hero(
                      tag: s.nombre, // Efecto visual al navegar
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          s.imagen,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      s.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${s.ubicacion}\n\$${s.precio.toInt()}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${s.rating}',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceDetailScreen(service: s),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
