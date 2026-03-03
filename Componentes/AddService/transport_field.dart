import 'package:flutter/material.dart';

class TransportField extends StatelessWidget {
  final bool visible;
  final TextEditingController controller;

  const TransportField({
    super.key,
    required this.visible,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Medios de transporte',
            border: OutlineInputBorder(),
          ),
          validator: (v) => v!.isEmpty ? 'Requerido' : null,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
