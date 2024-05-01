import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  MyPainter(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue // Color of the box
      ..style = PaintingStyle.stroke // Stroke style
      ..strokeWidth = 2.0; // Stroke width

    // Draw the box on the canvas
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}