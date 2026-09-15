import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../theme/circuit_background_painter.dart';

/// Paints the circuit mesh behind a screen, adapting its colours to the
/// active [Brightness]. Place it as the bottom-most layer of a [Stack]:
///
/// ```dart
/// Scaffold(
///   body: Stack(children: [
///     const Positioned.fill(child: CircuitBackground()),
///     ...content,
///   ]),
/// )
/// ```
class CircuitBackground extends StatelessWidget {
  const CircuitBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    final bool isDark = brightness == Brightness.dark;

    final Color traceColor = isDark
        ? Colors.white.withValues(alpha: 0.045)
        : Colors.black.withValues(alpha: 0.05);
    final Color nodeColor = isDark
        ? AppColors.accentTeal.withValues(alpha: 0.30)
        : const Color(0xFF0F766E).withValues(alpha: 0.22);

    return SizedBox.expand(
      child: CustomPaint(
        painter: CircuitPainter(
          traceColor: traceColor,
          nodeColor: nodeColor,
        ),
      ),
    );
  }
}