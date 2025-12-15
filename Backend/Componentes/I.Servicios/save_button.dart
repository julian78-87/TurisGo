import 'dart:io';

import 'package:flutter/material.dart';
import 'supabase_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ElevatedButton(
            onPressed: () {
              SupabaseService.saveService(
                formKey: formKey,
                isVerified: isVerified,
                name: name,
                description: description,
                category: category,
                address: address,
                transport: transport,
                priceText: priceText,
                image: image,
                onLoadingChange: onLoadingChange,
                onSuccess: onSuccess,
                context: context,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(18),
              backgroundColor: Colors.teal,
            ),
            child: const Text(
              'GUARDAR SERVICIO TURÍSTICO',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
  }
}
