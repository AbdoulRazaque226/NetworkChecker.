import 'package:flutter/material.dart';

import '../gen_l10n/app_localizations.dart';

class ExportButton extends StatelessWidget {
  const ExportButton({super.key, required this.onPressed, this.isLoading = false});

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Icon(Icons.ios_share_rounded),
      label: Text(
        isLoading ? l10n.history_exporting : l10n.history_export,
      ),
    );
  }
}