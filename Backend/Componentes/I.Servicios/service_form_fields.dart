import 'package:flutter/material.dart';

class ServiceFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController addrController;
  final TextEditingController priceController;
  final String category;
  final List<String> categories;
  final Function(String) onCategoryChanged;

  const ServiceFormFields({
    super.key,
    required this.nameController,
    required this.descController,
    required this.priceController,
    required this.addrController,
    required this.category,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: descController,
          decoration: const InputDecoration(
            labelText: 'Descripción',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
        const SizedBox(height: 12),

        DropdownButtonFormField<String>(
          value: category,
          items: categories
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onCategoryChanged(v!),
          decoration: const InputDecoration(
            labelText: 'Categoría',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: addrController,
          decoration: const InputDecoration(
            labelText: 'Dirección',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v!.isEmpty ? 'La dirección es obligatoria' : null,
        ),
      ],
    );
  }
}
