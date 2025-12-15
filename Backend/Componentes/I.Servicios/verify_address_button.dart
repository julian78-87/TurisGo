import 'package:flutter/material.dart';

class VerifyAddressButton extends StatelessWidget {
  final String address;
  final bool isVerified;
  final VoidCallback onVerify;
  final BuildContext context;

  const VerifyAddressButton({
    super.key,
    required this.address,
    required this.isVerified,
    required this.onVerify,
    required this.context,
  });

  Future<void> _verify() async {
    if (address.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe la dirección para verificar')),
      );
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    onVerify();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dirección verificada'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isVerified ? null : _verify,
      style: ElevatedButton.styleFrom(
        backgroundColor: isVerified ? Colors.grey : Colors.teal,
      ),
      child: Text(
        isVerified ? 'Verificado' : 'Verificar datos',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
