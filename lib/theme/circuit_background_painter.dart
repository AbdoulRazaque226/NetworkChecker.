import 'package:flutter/material.dart';

/// Paints a procedural circuit-board / signal-mesh texture.
///
/// The pattern is a fine grid of traces with small "solder nodes" at scattered
/// intersections and short diagonal stubs, evoking a printed circuit board.
/// It is fully generated in code (no image assets) and resolution-independent,
/// so it scales on any device and works in both light and dark themes by simply
/// swapping the colours.
class CircuitPainter extends CustomPainter {
  const CircuitPainter({
    required this.traceColor,
    required this.nodeColor,
    this.cellSize = 34.0,
  });

  /// Colour of the grid traces (faint, slightly lighter/darker than the bg).
  final Color traceColor;

  /// Colour of the node dots scattered across the mesh.
  final Color nodeColor;

  /// Spacing between vertical/horizontal traces, in logical pixels.
  final double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint trace = Paint()
      ..color = traceColor
      ..strokeWidth = 1;

    final int cols = (size.width / cellSize).ceil() + 1;
    final int rows = (size.height / cellSize).ceil() + 1;
    final double nodeRadius = 1.6;

    // Horizontal and vertical grid lines.
    for (int x = 0; x <= cols; x++) {
      final double dx = x * cellSize;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), trace);
    }
    for (int y = 0; y <= rows; y++) {
      final double dy = y * cellSize;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), trace);
    }

    // Solder nodes + short diagonal stubs at scattered intersections.
    // A deterministic pseudo-random pick (hash of the cell index) keeps the
    // pattern stable from frame to frame.
    final Paint node = Paint()..color = nodeColor;
    final Paint stub = Paint()
      ..color = nodeColor.withValues(alpha: 0.35)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        final int hash = (x * 73856093) ^ (y * 19349663);
        if (_hash01(hash) > 0.30) continue;

        final Offset p = Offset(x * cellSize, y * cellSize);
        // Corner nodes are smaller; interior ones are dots.
        canvas.drawCircle(p, nodeRadius, node);

        // A short diagonal trace sometimes branches off the node.
        if (_hash01(hash >> 3) > 0.6) {
          final double dx = cellSize * 0.28;
          final double dy = cellSize * 0.28;
          switch (hash % 4) {
            case 0:
              canvas.drawLine(p, p + Offset(dx, dy), stub);
            case 1:
              canvas.drawLine(p, p + Offset(-dx, dy), stub);
            case 2:
              canvas.drawLine(p, p + Offset(dx, -dy), stub);
            default:
              canvas.drawLine(p, p + Offset(-dx, -dy), stub);
          }
        }
      }
    }

    // A few longer horizontal "bus" traces across random rows.
    final Paint bus = Paint()
      ..color = nodeColor.withValues(alpha: 0.14)
      ..strokeWidth = 2.5;
    for (int i = 0; i < 4; i++) {
      final int y = (i * 37 + rows ~/ 2) % rows;
      final double dy = y * cellSize;
      final double start = (hashOfDelay(y) % cols) * cellSize;
      final double len = cellSize * (2 + (y % 3));
      canvas.drawLine(
        Offset(start, dy),
        Offset((start + len).clamp(0, size.width), dy),
        bus,
      );
    }
  }

  /// 0..1 deterministic hash from a seed.
  static double _hash01(int seed) {
    final int v = (seed ^ (seed >> 16)) & 0x0FFFFFFF;
    return (v % 100000) / 100000.0;
  }

  /// Another stable pseudo-random source for the bus traces.
  static int hashOfDelay(int seed) {
    final int n = (seed * 2654435761) & 0x7FFFFFFF;
    return n;
  }

  @override
  bool shouldRepaint(covariant CircuitPainter oldDelegate) =>
      oldDelegate.traceColor != traceColor ||
      oldDelegate.nodeColor != nodeColor ||
      oldDelegate.cellSize != cellSize;
}