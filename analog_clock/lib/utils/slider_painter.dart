import 'dart:math';

import 'package:flutter/material.dart';

class SliderPainter extends CustomPainter {
  double startAngle;
  double endAngle;
  double sweepAngle;
  Color selectionColor;

  Offset initHandler;
  Offset endHandler;
  Offset center;
  double radius;
  double strokeWidth;

  SliderPainter(
      {@required this.startAngle,
      @required this.endAngle,
      @required this.sweepAngle,
      @required this.selectionColor,
      @required this.radius,
      @required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    if (startAngle == 0.0 && endAngle == 0.0) return;

    Paint progress = _getPaint(color: selectionColor, width: strokeWidth);

    center = Offset(size.width / 2, size.height / 2);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2 + startAngle, sweepAngle, false, progress);

    Paint split =
        _getPaint(color: Colors.white.withOpacity(0.4), width: strokeWidth);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle - pi / 2, endAngle, false, split);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Paint _getPaint({@required Color color, double width, PaintingStyle style}) =>
      Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = style ?? PaintingStyle.stroke
        ..strokeWidth = width ?? 12.0;
}
