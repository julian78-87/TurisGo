import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

final supabase = Supabase.instance.client;

class SupabaseService {
  static Future<void> saveService({
    required GlobalKey<FormState> formKey,
    required bool isVerified,
    required String name,
    required String description,
    required String category,
    required String address,
    required String transport,
    required String priceText,
    required File? image,
    required Function(bool) onLoadingChange,
    required VoidCallback onSuccess,
    required BuildContext context,
  }) async {
    if (!formKey.currentState!.validate()) return;
    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes verificar la dirección primero')),
      );
      return;
    }

    onLoadingChange(true);

    String? url;
    if (image != null) {
      final name = 'services/${DateTime.now().millisecondsSinceEpoch}.jpg';
      try {
        await supabase.storage
            .from('services')
            .upload(name, image, fileOptions: const FileOptions(upsert: true));
        url = supabase.storage.from('services').getPublicUrl(name);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error subiendo foto: $e')));
        }
      }
    }

    try {
      await supabase.from('services').insert({
        'name': name.trim(),
        'description': description.trim(),
        'category': category,
        'address': address.trim(),
        'transport': transport.trim(),
        'price': priceText.isNotEmpty ? double.tryParse(priceText) : null,
        'verified': isVerified,
        'image_url': url,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Publicado correctamente!'),
            backgroundColor: Colors.green,
          ),
        );
        onSuccess();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (context.mounted) onLoadingChange(false);
    }
  }
}
