import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:evv/Componentes/General/Datos.dart'; // Importante para acceder a AppData.currentUser

class SaveButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isVerified;
  final bool isLoading;
  final String name;
  final String description;
  final String category;
  final String address;
  final String transport;
  final String priceText;
  final File? image;
  final Function(bool) onLoadingChange;
  final VoidCallback onSuccess;
  final BuildContext context;

  const SaveButton({
    super.key,
    required this.formKey,
    required this.isVerified,
    required this.isLoading,
    required this.name,
    required this.description,
    required this.category,
    required this.address,
    required this.transport,
    required this.priceText,
    required this.image,
    required this.onLoadingChange,
    required this.onSuccess,
    required this.context,
  });

  Future<void> _handleSave() async {
    // 1. Validaciones previas
    if (!formKey.currentState!.validate()) return;

    // Si la categoría requiere verificación y no está verificado
    final alojCats = ['Casa', 'Hotel', 'Hostal', 'Apartamento'];
    if (alojCats.contains(category) && !isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, verifica la dirección primero'),
        ),
      );
      return;
    }

    onLoadingChange(true);
    final supabase = Supabase.instance.client;

    try {
      String? imageUrl;

      // 2. Subida de imagen al bucket 'services'
      if (image != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final path = 'public/$fileName';

        await supabase.storage.from('services').upload(path, image!);
        imageUrl = supabase.storage.from('services').getPublicUrl(path);
      }

      // 3. Inserción en la tabla 'services'
      await supabase.from('services').insert({
        'name': name,
        'description': description,
        'category': category,
        'address': address,
        'transport': transport,
        'price': double.tryParse(priceText) ?? 0.0,
        'verified': isVerified,
        'image_url': imageUrl,
        // Sacamos el proveedor directamente de tus datos globales
        'proveedor': AppData.currentUser['nombre'],
      });

      onSuccess();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      onLoadingChange(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'PUBLICAR SERVICIO',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          );
  }
}
