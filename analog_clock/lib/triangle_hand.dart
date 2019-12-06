import 'package:flutter/material.dart';

class DrawTriangle extends CustomPainter {

  Paint _paint;

  DrawTriangle() {
    _paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
//    path.moveTo(size.width/100, 0);
    path.lineTo(0, size.height/50);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}