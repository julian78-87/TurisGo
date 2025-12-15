import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://btzjedxvgtscuhjeiikq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ0emplZHh2Z3RzY3VoamVpaWtxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM3MTcwMzEsImV4cCI6MjA3OTI5MzAzMX0.uGgjlAHvoSh0n-Mu3IR-mVCyI0aDMmn0lMycaVa8uwA',
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turismo Local',
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de Servicios Turísticos'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase
            .from('services')
            .stream(primaryKey: ['id'])
            .order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final services = snapshot.data!;
          if (services.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.card_travel, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay servicios publicados',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: services.length,
            itemBuilder: (context, i) => ServiceCard(data: services[i]),
          );
        },
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const ServiceCard({super.key, required this.data});

  Future<void> _delete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar servicio'),
        content: const Text('¿Estás seguro? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await supabase.from('services').delete().eq('id', data['id']);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Servicio eliminado')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  void _edit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddServicePage(existingData: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esAlojamiento = [
      'Casa',
      'Hotel',
      'Hostal',
      'Apartamento',
    ].contains(data['category']);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: data['image_url'] != null
                  ? Image.network(
                      data['image_url'],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[300],
                      child: const Icon(Icons.hotel, size: 40),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] ?? 'Sin nombre',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.category, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(data['category']),
                      if (esAlojamiento && data['verified'] == true) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 18,
                        ),
                        const Text(
                          ' Verificado',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ],
                  ),
                  if (data['description']?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        data['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  if (data['price'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '\$${data['price']} / noche',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.directions_bus, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Transporte: ${data['transport']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) {
                if (value == 'edit') _edit(context);
                if (value == 'delete') _delete(context);
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 10),
                      Text('Editar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 10),
                      Text('Eliminar'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddServicePage extends StatefulWidget {
  final Map<String, dynamic> existingData;
  const AddServicePage({super.key, required this.existingData});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _addr = TextEditingController();
  final _trans = TextEditingController();
  final _price = TextEditingController();

  String _cat = 'Casa';
  bool _verif = false;
  File? _image;
  String? _existingImageUrl;
  bool _loading = false;

  final cats = [
    'Casa',
    'Hotel',
    'Hostal',
    'Apartamento',
    'Restaurante',
    'Tour',
    'Transporte',
    'Otro',
  ];
  final alojCats = ['Casa', 'Hotel', 'Hostal', 'Apartamento'];

  @override
  void initState() {
    super.initState();
    final d = widget.existingData;
    _name.text = d['name'] ?? '';
    _desc.text = d['description'] ?? '';
    _addr.text = d['address'] ?? '';
    _trans.text = d['transport'] ?? '';
    _price.text = d['price']?.toString() ?? '';
    _cat = d['category'] ?? 'Casa';
    _verif = d['verified'] ?? false;
    _existingImageUrl = d['image_url'];
  }

  Future<void> _pick() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<void> _verify() async {
    if (!alojCats.contains(_cat)) {
      setState(() => _verif = true);
      return;
    }
    if (_addr.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Dirección requerida')));
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _verif = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verificado'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (alojCats.contains(_cat) && !_verif) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Verifica el alojamiento')));
      return;
    }

    setState(() => _loading = true);

    String? url = _existingImageUrl;
    if (_image != null) {
      final name = 'services/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await supabase.storage
          .from('services')
          .upload(name, _image!, fileOptions: const FileOptions(upsert: true));
      url = supabase.storage.from('services').getPublicUrl(name);
    }

    final payload = {
      'name': _name.text.trim(),
      'description': _desc.text.trim(),
      'category': _cat,
      'address': _addr.text.trim(),
      'transport': _trans.text.trim(),
      'price': _price.text.isNotEmpty ? double.tryParse(_price.text) : null,
      'verified': _verif,
      'image_url': url,
    };

    try {
      await supabase
          .from('services')
          .update(payload)
          .eq('id', widget.existingData['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Servicio actualizado correctamente!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Servicio')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pick,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : (_existingImageUrl != null
                          ? Image.network(_existingImageUrl!, fit: BoxFit.cover)
                          : const Icon(Icons.add_a_photo, size: 60)),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _desc,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _cat,
              items: cats
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _cat = v!),
              decoration: const InputDecoration(
                labelText: 'Categoría',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (alojCats.contains(_cat)) ...[
              TextFormField(
                controller: _addr,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              ElevatedButton(
                onPressed: _verif ? null : _verify,
                child: Text(_verif ? 'Verificado' : 'Verificar'),
              ),
              const SizedBox(height: 12),
            ],
            TextFormField(
              controller: _trans,
              decoration: const InputDecoration(
                labelText: 'Transporte',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _price,
              decoration: const InputDecoration(
                labelText: 'Precio (opcional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      backgroundColor: Colors.teal,
                    ),
                    child: const Text(
                      'GUARDAR CAMBIOS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
