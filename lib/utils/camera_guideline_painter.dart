import 'dart:math';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CameraGuidelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8.sp
      ..style = PaintingStyle.stroke;

    final double cornerLength = 26.sp;
    final double rectWidth = 70.w;
    final double rectHeight = 50.h;  // 60% of the screen height
    final double cornerRadius = 16.sp;

    final double left = (100.w - rectWidth) / 2;
    final double top = (100.h - rectHeight) / 2;
    final double right = left + rectWidth;
    final double bottom = top + rectHeight;

    // Top Left Corner
    canvas.drawLine(Offset(left + cornerRadius, top), Offset(left + cornerLength, top), paint);
    canvas.drawLine(Offset(left, top + cornerRadius), Offset(left, top + cornerLength), paint);
    canvas.drawArc(Rect.fromCircle(center: Offset(left + cornerRadius, top + cornerRadius), radius: cornerRadius), pi, pi / 2, false, paint);

    // Top Right Corner
    canvas.drawLine(Offset(right - cornerRadius, top), Offset(right - cornerLength, top), paint);
    canvas.drawLine(Offset(right, top + cornerRadius), Offset(right, top + cornerLength), paint);
    canvas.drawArc(Rect.fromCircle(center: Offset(right - cornerRadius, top + cornerRadius), radius: cornerRadius), -pi / 2, pi / 2, false, paint);

    // Bottom Left Corner
    canvas.drawLine(Offset(left + cornerRadius, bottom), Offset(left + cornerLength, bottom), paint);
    canvas.drawLine(Offset(left, bottom - cornerRadius), Offset(left, bottom - cornerLength), paint);
    canvas.drawArc(Rect.fromCircle(center: Offset(left + cornerRadius, bottom - cornerRadius), radius: cornerRadius), pi / 2, pi / 2, false, paint);

    // Bottom Right Corner
    canvas.drawLine(Offset(right - cornerRadius, bottom), Offset(right - cornerLength, bottom), paint);
    canvas.drawLine(Offset(right, bottom - cornerRadius), Offset(right, bottom - cornerLength), paint);
    canvas.drawArc(Rect.fromCircle(center: Offset(right - cornerRadius, bottom - cornerRadius), radius: cornerRadius), 0, pi / 2, false, paint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}