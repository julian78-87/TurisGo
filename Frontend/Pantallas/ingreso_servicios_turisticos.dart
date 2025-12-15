import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
        title: const Text('Servicios Turísticos'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, size: 34),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddServicePage()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase.from('services').stream(primaryKey: ['id']),
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
              child: Text(
                '¡Sé el primero en publicar!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: services.length,
            padding: const EdgeInsets.all(12),
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

  @override
  Widget build(BuildContext context) {
    final esAlojamiento = [
      'Casa',
      'Hotel',
      'Hostal',
      'Apartamento',
    ].contains(data['category']);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: data['image_url'] != null
              ? Image.network(
                  data['image_url'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.grey[300],
                  width: 80,
                  height: 80,
                  child: const Icon(Icons.photo),
                ),
        ),
        title: Text(
          data['name'] ?? 'Sin nombre',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data['category']} ${esAlojamiento && data['verified'] == true ? '✓ Verificado' : ''}',
            ),
            Text(data['description'] ?? '', maxLines: 2),
            if (data['price'] != null)
              Text(
                '\$${data['price']} / noche',
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              'Transporte: ${data['transport']}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});
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
      ).showSnackBar(const SnackBar(content: Text('Escribe la dirección')));
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifica el alojamiento primero')),
      );
      return;
    }

    setState(() => _loading = true);

    String? url;
    if (_image != null) {
      final name = 'services/${DateTime.now().millisecondsSinceEpoch}.jpg';
      try {
        await supabase.storage
            .from('services')
            .upload(
              name,
              _image!,
              fileOptions: const FileOptions(upsert: true),
            );
        url = supabase.storage.from('services').getPublicUrl(name);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error subiendo foto: $e')));
        }
      }
    }

    try {
      await supabase.from('services').insert({
        'name': _name.text.trim(),
        'description': _desc.text.trim(),
        'category': _cat,
        'address': _addr.text.trim(),
        'transport': _trans.text.trim(),
        'price': _price.text.isNotEmpty ? double.tryParse(_price.text) : null,
        'verified': _verif,
        'image_url': url,
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Publicado correctamente!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error guardando: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Servicio')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pick,
              child: Container(
                height: 200,
                color: Colors.grey[200],
                child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : const Icon(Icons.add_a_photo, size: 60),
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
                child: Text(_verif ? 'Verificado' : 'Verificar alojamiento'),
              ),
              const SizedBox(height: 12),
            ],

            TextFormField(
              controller: _trans,
              decoration: const InputDecoration(
                labelText: 'Transporte cercano (ejemplo: bus ruta 40) ',
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
                    ),
                    child: const Text(
                      'GUARDAR Y PUBLICAR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
