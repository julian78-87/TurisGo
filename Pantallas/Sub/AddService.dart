import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:evv/Componentes/AddService/verify_address_button.dart';
import 'package:evv/Componentes/AddService/image_picker_section.dart';
import 'package:evv/Componentes/AddService/service_form_fields.dart';
import 'package:evv/Componentes/AddService/transport_field.dart';
import 'package:evv/Componentes/AddService/save_button.dart';
import 'package:evv/Componentes/AddService/app_constants.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key, this.serviceToEdit});

  final Map<String, dynamic>? serviceToEdit;

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();

  final colorFondo = const Color(0xFFF8FAFC);
  final colorCoral = const Color(0xFFFF6B6B);
  final colorCerceta = const Color(0xFF0D9488);
  final colorTexto = const Color(0xFF1E293B);

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _addrController = TextEditingController();
  final _transController = TextEditingController();
  final _priceController = TextEditingController();
  final _customCatController = TextEditingController();

  String _categoria = 'Casa';
  bool _isVerified = false;
  XFile? _image; // <-- CAMBIADO DE File? A XFile?
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.serviceToEdit != null) {
      final s = widget.serviceToEdit!;
      _nameController.text = s['name'] ?? '';
      _descController.text = s['description'] ?? '';
      _addrController.text = s['address'] ?? '';
      _transController.text = s['transport'] ?? '';
      _priceController.text = s['price'].toString();
      _categoria = s['category'] ?? 'Casa';
      _isVerified = true;
    }

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
      backgroundColor: colorFondo,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'NUEVO SERVICIO',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
        backgroundColor: colorFondo,
        foregroundColor: colorTexto,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          children: [
            const Text(
              "Foto de portada",
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ImagePickerSection(
              image: _image,
              onImagePicked: (file) => setState(() => _image = file),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: colorTexto.withOpacity(0.03)),
              ),
              child: Column(
                children: [
                  ServiceFormFields(
                    nameController: _nameController,
                    descController: _descController,
                    addrController: _addrController,
                    priceController: _priceController,
                    category: _categoria,
                    categories: AppConstants.categories,
                    onCategoryChanged: (val) =>
                        setState(() => _categoria = val),
                  ),
                  if (_categoria == 'Otro') ...[
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _customCatController,
                      decoration: InputDecoration(
                        labelText: '¿Qué tipo de servicio es?',
                        prefixIcon: Icon(Icons.edit_note, color: colorCoral),
                      ),
                      validator: (v) => _categoria == 'Otro' && v!.isEmpty
                          ? 'Por favor especifica'
                          : null,
                    ),
                  ],
                  const SizedBox(height: 20),
                  if (AppConstants.alojCats.contains(_categoria))
                    VerifyAddressButton(
                      addressController: _addrController,
                      isVerified: _isVerified,
                      onVerify: () => setState(() => _isVerified = true),
                    ),
                  const Divider(height: 40, thickness: 1),
                  TransportField(visible: true, controller: _transController),
                ],
              ),
            ),
            const SizedBox(height: 40),
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
              image:
                  _image, // Aquí ya no debería haber error si SaveButton usa XFile?
              onLoadingChange: (val) => setState(() => _isLoading = val),
              onSuccess: () {
                Navigator.pop(context);
              },
              context: context,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
