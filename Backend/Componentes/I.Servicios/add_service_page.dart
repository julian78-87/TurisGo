import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
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

  void _updateImage(File? newImage) {
    setState(() => _image = newImage);
  }

  void _updateCategory(String newCat) {
    setState(() => _cat = newCat);
  }

  void _updateVerified(bool verified) {
    setState(() => _verif = verified);
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
              address: _addr.text,
              isVerified: _verif,
              onVerify: () => _updateVerified(true),
              context: context,
            ),

            TransportField(
              visible: _cat.toLowerCase() != 'transporte',
              controller: _trans,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _price,
              decoration: const InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Requerido' : null,
            ),
            const SizedBox(height: 30),
            SaveButton(
              formKey: _formKey,
              isVerified: _verif,
              isLoading: _loading,
              name: _name.text,
              description: _desc.text,
              category: _cat,
              address: _addr.text,
              transport: _trans.text,
              priceText: _price.text,
              image: _image,
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
