import 'dart:io';
import 'package:flutter/material.dart';
import 'package:evv/Componentes/AddService.dart/verify_address_button.dart';
import 'package:evv/Componentes/AddService.dart/image_picker_section.dart';
import 'package:evv/Componentes/AddService.dart/service_form_fields.dart';
import 'package:evv/Componentes/AddService.dart/transport_field.dart';
import 'package:evv/Componentes/AddService.dart/save_button.dart';
import 'package:evv/Componentes/AddService.dart/app_constants.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _addrController = TextEditingController();
  final _transController = TextEditingController();
  final _priceController = TextEditingController();
  final _customCatController = TextEditingController();

  String _categoria = 'Casa'; // Valor inicial
  bool _isVerified = false;
  File? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addrController.addListener(() {
      if (_isVerified) setState(() => _isVerified = false);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _addrController.dispose();
    _transController.dispose();
    _priceController.dispose();
    _customCatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Servicio Turístico'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ImagePickerSection(
              image: _image,
              onImagePicked: (file) => setState(() => _image = file),
            ),

            const SizedBox(height: 24),

            ServiceFormFields(
              nameController: _nameController,
              descController: _descController,
              addrController: _addrController,
              priceController: _priceController,
              category: _categoria,
              categories: AppConstants.categories,
              onCategoryChanged: (val) => setState(() => _categoria = val),
            ),

            if (_categoria == 'Otro') ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _customCatController,
                decoration: const InputDecoration(
                  labelText: 'Especifique la categoría',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit_note),
                ),
                validator: (v) =>
                    _categoria == 'Otro' && v!.isEmpty ? 'Requerido' : null,
              ),
            ],

            const SizedBox(height: 12),

            if (AppConstants.alojCats.contains(_categoria))
              VerifyAddressButton(
                addressController: _addrController,
                isVerified: _isVerified,
                onVerify: () => setState(() => _isVerified = true),
              ),

            // 5. Campo de Transporte
            TransportField(visible: true, controller: _transController),

            const SizedBox(height: 40),

            // Botón de Guardar que conecta a Supabase
            SaveButton(
              formKey: _formKey,
              isVerified: _isVerified,
              isLoading: _isLoading,
              name: _nameController.text,
              description: _descController.text,
              category: _categoria == 'Otro'
                  ? _customCatController.text
                  : _categoria,
              address: _addrController.text,
              transport: _transController.text,
              priceText: _priceController.text,
              image: _image,
              onLoadingChange: (val) => setState(() => _isLoading = val),
              onSuccess: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Servicio publicado correctamente'),
                  ),
                );
                Navigator.pop(context);
              },
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
