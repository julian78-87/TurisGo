import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Aún lo usamos para plataformas móviles

class ImagePickerSection extends StatelessWidget {
  // Cambiamos File por XFile para compatibilidad web
  final XFile? image;
  final Function(XFile?) onImagePicked;

  const ImagePickerSection({
    super.key,
    required this.image,
    required this.onImagePicked,
  });

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) onImagePicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: kIsWeb
                    ? Image.network(
                        image!.path,
                        fit: BoxFit.cover,
                      ) // Solución para Web
                    : Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                      ), // Solución para Móvil
              )
            : const Icon(Icons.add_a_photo, size: 60, color: Colors.grey),
      ),
    );
  }
}
