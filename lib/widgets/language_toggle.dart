import 'package:flutter/material.dart';

import '../providers/language_provider.dart';

/// FR/EN toggle button shown in app bars.
///
/// Renders the target language code as the button label so the user always
/// knows the switch will change to. Calls [LanguageProvider.toggleLocale].
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key, required this.languageProvider});

  final LanguageProvider languageProvider;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: languageProvider,
      builder: (context, _) {
        final bool nowFr = languageProvider.locale.languageCode == 'fr';
        return Tooltip(
          message: nowFr ? 'Switch to English' : 'Passer en français',
          child: TextButton.icon(
            onPressed: languageProvider.toggleLocale,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size(0, 32),
            ),
            icon: const Icon(Icons.language_rounded, size: 18),
            label: Text(
              nowFr ? 'EN' : 'FR',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        );
      },
    );
  }
}