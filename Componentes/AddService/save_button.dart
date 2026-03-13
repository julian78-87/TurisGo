import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final XFile? image;
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

  Future<void> _saveService() async {
    if (!formKey.currentState!.validate()) return;
    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, verifica la dirección primero'),
        ),
      );
      return;
    }
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una imagen')),
      );
      return;
    }

    onLoadingChange(true);

    try {
      final supabase = Supabase.instance.client;

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      final imageBytes = await image!.readAsBytes();

      await supabase.storage
          .from('services-images')
          .uploadBinary(
            fileName,
            imageBytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      final imageUrl = supabase.storage
          .from('services-images')
          .getPublicUrl(fileName);

      await supabase.from('services').insert({
        'name': name,
        'description': description,
        'category': category,
        'address': address,
        'transport': transport,
        'price': double.tryParse(priceText) ?? 0.0,
        'image_url': imageUrl,
      });

      onSuccess();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Servicio guardado exitosamente!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    } finally {
      onLoadingChange(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : _saveService,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'GUARDAR SERVICIO',
              style: TextStyle(color: Colors.white),
            ),
    );
  }
}
