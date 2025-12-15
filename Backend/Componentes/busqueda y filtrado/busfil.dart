import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Búsqueda y Filtrado',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      ),
      home: const SearchFilterPage(),
    );
  }
}

class ServiceItem {
  final String id;
  final String title;
  final String category;
  final String location;
  final String serviceType;
  final double price;
  final String description;

  ServiceItem({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.serviceType,
    required this.price,
    required this.description,
  });
}

class SearchFilterPage extends StatefulWidget {
  const SearchFilterPage({super.key});

  @override
  State<SearchFilterPage> createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  final List<ServiceItem> _allItems = [
    ServiceItem(
      id: '1',
      title: 'Tour por el Jardín Botánico San Jorge',
      category: 'Cultural',
      location: 'Ibagué',
      serviceType: 'Tour',
      price: 25.0,
      description: 'Recorrido guiado y caminata ecológica.',
    ),
    ServiceItem(
      id: '2',
      title: 'Alojamiento céntrico',
      category: 'Alojamiento',
      location: 'Ibagué',
      serviceType: 'Alojamiento',
      price: 50.0,
      description: 'Hotel 3 estrellas cerca del centro.',
    ),
    ServiceItem(
      id: '3',
      title: 'Parque Museo La Martinica',
      category: 'Naturaleza',
      location: 'Ibagué',
      serviceType: 'Tour',
      price: 40.0,
      description: 'Senderismo, naturaleza e historia.',
    ),
    ServiceItem(
      id: '4',
      title: 'Experiencia gastronómica',
      category: 'Gastronomía',
      location: 'Ibagué',
      serviceType: 'Actividad',
      price: 35.0,
      description: 'Cena con platos típicos y música en vivo.',
    ),
  ];

  String _searchQuery = '';
  String _selectedCategory = 'Todas';
  String _selectedLocation = 'Todas';
  String _selectedServiceType = 'Todas';
  late RangeValues _priceRange;

  List<String> get _categories => [
    'Todas',
    ..._allItems.map((e) => e.category).toSet(),
  ];

  List<String> get _locations => [
    'Todas',
    ..._allItems.map((e) => e.location).toSet(),
  ];

  List<String> get _serviceTypes => [
    'Todas',
    ..._allItems.map((e) => e.serviceType).toSet(),
  ];

  double get _minPrice =>
      _allItems.map((e) => e.price).reduce((a, b) => a < b ? a : b);

  double get _maxPrice =>
      _allItems.map((e) => e.price).reduce((a, b) => a > b ? a : b);

  List<ServiceItem> get _filteredItems {
    final q = _searchQuery.trim().toLowerCase();

    return _allItems.where((item) {
      final matchesQuery =
          q.isEmpty ||
          item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q);

      final matchesCategory =
          _selectedCategory == 'Todas' || item.category == _selectedCategory;

      final matchesLocation =
          _selectedLocation == 'Todas' || item.location == _selectedLocation;

      final matchesServiceType =
          _selectedServiceType == 'Todas' ||
          item.serviceType == _selectedServiceType;

      final matchesPrice =
          item.price >= _priceRange.start && item.price <= _priceRange.end;

      return matchesQuery &&
          matchesCategory &&
          matchesLocation &&
          matchesServiceType &&
          matchesPrice;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(_minPrice, _maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredItems;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Búsqueda y Filtrado'),
        backgroundColor: const Color.fromARGB(255, 236, 237, 239),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 160, 137, 197), Color(0xFFF5F5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Buscador
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Buscar destinos, servicios o actividades',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                ),
                onChanged: (v) => setState(() => _searchQuery = v.trim()),
              ),

              const SizedBox(height: 12),

              // Filtros
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: _categories
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (v) => setState(() => _selectedCategory = v!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      items: _locations
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Ubicación',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (v) => setState(() => _selectedLocation = v!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedServiceType,
                      items: _serviceTypes
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Tipo de servicio',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (v) =>
                          setState(() => _selectedServiceType = v!),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Rango de precios
              Text(
                'Rango de precios: \$${_priceRange.start.toStringAsFixed(0)} - \$${_priceRange.end.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white),
              ),

              RangeSlider(
                values: _priceRange,
                min: _minPrice,
                max: _maxPrice,
                divisions: _maxPrice > _minPrice
                    ? (_maxPrice - _minPrice).round()
                    : null,
                labels: RangeLabels(
                  _priceRange.start.toStringAsFixed(0),
                  _priceRange.end.toStringAsFixed(0),
                ),
                onChanged: (r) => setState(() => _priceRange = r),
              ),

              const SizedBox(height: 12),

              // Resultados
              Expanded(
                child: results.isEmpty
                    ? Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'No se encontraron resultados para los filtros aplicados.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 85, 5, 5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: results.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return ListTile(
                            tileColor: Colors.white,
                            title: Text(item.title),
                            subtitle: Text(
                              '${item.category} • ${item.location} • ${item.serviceType}',
                            ),
                            trailing: Text(
                              '\$${item.price.toStringAsFixed(0)}',
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(item.title),
                                  content: Text(
                                    '${item.description}\n\nPrecio: \$${item.price.toStringAsFixed(0)}',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cerrar'),
                                    ),
                                  ],
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
    );
  }
}
