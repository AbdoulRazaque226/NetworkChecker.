import 'package:flutter/material.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key, required this.onPressed, this.isLoading = false});

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.download),
      label: Text(isLoading ? 'Export en cours...' : 'Exporter en JSON'),
    );
  }
}