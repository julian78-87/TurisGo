import 'package:flutter/material.dart';

class VerifyAddressButton extends StatelessWidget {
  final TextEditingController addressController;
  final bool isVerified;
  final VoidCallback onVerify;

  const VerifyAddressButton({
    super.key,
    required this.addressController,
    required this.isVerified,
    required this.onVerify,
  });

  Future<void> _verify(BuildContext context) async {
    // Leemos el texto directamente del controlador en el momento del click
    final currentAddress = addressController.text.trim();

    if (currentAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe la dirección para verificar')),
      );
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    onVerify();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dirección verificada correctamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Si ya está verificado, el botón se deshabilita
      onPressed: isVerified ? null : () => _verify(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: isVerified ? Colors.grey : Colors.teal,
        foregroundColor: Colors.white,
      ),
      child: Text(isVerified ? '✓ Verificado' : 'Verificar datos'),
    );
  }
}
