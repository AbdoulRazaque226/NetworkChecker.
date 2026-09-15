import 'package:flutter/material.dart';

import '../gen_l10n/app_localizations.dart';
import '../widgets/circuit_background.dart';

/// Explains how NetworkChecker works: the native layer, Flutter processing,
/// Firebase storage and JSON export.
class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final List<Widget> sections = <Widget>[
      _Section(
        icon: Icons.layers_rounded,
        color: theme.colorScheme.primary,
        title: l10n.how_architectureTitle,
        body: l10n.how_architectureBody,
      ),
      _Section(
        icon: Icons.phone_android_rounded,
        color: theme.colorScheme.secondary,
        title: l10n.how_nativeTitle,
        body: l10n.how_nativeBody,
      ),
      _Section(
        icon: Icons.memory_rounded,
        color: theme.colorScheme.primary,
        title: l10n.how_flutterTitle,
        body: l10n.how_flutterBody,
      ),
      _Section(
        icon: Icons.cloud_rounded,
        color: theme.colorScheme.secondary,
        title: l10n.how_firebaseTitle,
        body: l10n.how_firebaseBody,
      ),
      _Section(
        icon: Icons.ios_share_rounded,
        color: theme.colorScheme.primary,
        title: l10n.how_exportTitle,
        body: l10n.how_exportBody,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.how_title)),
      body: Stack(
        children: [
          const Positioned.fill(child: CircuitBackground()),
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                l10n.how_subtitle,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.route_rounded, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Native  →  Flutter  →  Firebase',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ...sections,
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}