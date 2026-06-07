import 'package:flutter/material.dart';

/// Paints a small filled downward-pointing triangle used as a map pin caret
/// below contact and service markers.
class DownwardTrianglePainter extends CustomPainter {
  final Color color;

  const DownwardTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant DownwardTrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}
