import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'image_picker_section.dart';
import 'service_form_fields.dart';
import 'verify_address_button.dart';
import 'transport_field.dart';
import 'save_button.dart';

final supabase = Supabase.instance.client;

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
  XFile? _image; // Cambiado de File? a XFile?
  bool _loading = false;

  final cats = [
    'Casa',
    'Hotel',
    'Hostal',
    'Apartamento',
    'Restaurante',
    'Otro',
  ];

  // Actualizado para recibir XFile
  void _updateImage(XFile? newImage) {
    setState(() => _image = newImage);
  }

  void _updateCategory(String newCat) {
    setState(() => _cat = newCat);
  }

  void _setLoading(bool loading) {
    setState(() => _loading = loading);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingresar Servicio Turístico'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // El componente ImagePickerSection que corregimos antes ya acepta XFile
            ImagePickerSection(image: _image, onImagePicked: _updateImage),
            const SizedBox(height: 20),
            ServiceFormFields(
              nameController: _name,
              descController: _desc,
              addrController: _addr,
              priceController: _price,
              category: _cat,
              categories: cats,
              onCategoryChanged: _updateCategory,
            ),
            const SizedBox(height: 8),
            VerifyAddressButton(
              addressController: _addr,
              isVerified: _verif,
              onVerify: () => setState(() => _verif = true),
            ),

            TransportField(
              visible: _cat.toLowerCase() != 'transporte',
              controller: _trans,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 30),
            SaveButton(
              formKey: _formKey,
              isVerified: _verif,
              isLoading: _loading,
              // Pasamos los valores actuales de los controladores
              name: _name.text,
              description: _desc.text,
              category: _cat,
              address: _addr.text,
              transport: _trans.text,
              priceText: _price.text,
              image: _image, // Ahora es XFile
              onLoadingChange: _setLoading,
              onSuccess: () {
                _name.clear();
                _desc.clear();
                _addr.clear();
                _trans.clear();
                _price.clear();
                setState(() {
                  _cat = 'Casa';
                  _verif = false;
                  _image = null;
                });
              },
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
