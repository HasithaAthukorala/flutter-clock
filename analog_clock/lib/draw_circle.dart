import 'package:flutter/material.dart';

class DrawCircle extends CustomPainter {
  Paint _paint;
  final Size screenSize;

  DrawCircle(this.screenSize) {
    _paint = Paint()
      ..color = Colors.white30
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0,0), screenSize.shortestSide * 0.5 * 0.6, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}