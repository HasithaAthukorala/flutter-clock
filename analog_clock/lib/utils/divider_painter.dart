import 'dart:math';

import 'package:flutter/material.dart';
import 'package:analog_clock/utils/utils.dart';

class DividerPainter extends CustomPainter {
  double startAngle;
  double endAngle;
  double sweepAngle;
  Color selectionColor;

  Offset initHandler;
  Offset endHandler;
  Offset center;
  double radius;
  double strokeWidth;
  double margin;
  double length;

  DividerPainter(
      {@required this.selectionColor,
        @required this.strokeWidth,
        @required this.margin,
        @required this.length
      });

  @override
  void paint(Canvas canvas, Size size) {
    if (startAngle == 0.0 && endAngle == 0.0) return;

    double unitLength = (size.height - (2*margin))/60;

    Paint progress = _getPaint(color: selectionColor, width: strokeWidth);
    canvas.drawLine(Offset(size.width/2,0 + margin), Offset(size.width/2, size.height - margin), progress);

    Paint split = _getPaint(color: Colors.white.withOpacity(0.4), width: strokeWidth);
    canvas.drawLine(Offset(size.width/2,0 + margin), Offset(size.width/2, length*unitLength + margin), split);
//    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
//        startAngle - pi / 2, endAngle, false, split);
  }

  Paint _getPaint({@required Color color, double width, PaintingStyle style}) =>
      Paint()
        ..color = color
        ..strokeCap = StrokeCap.round
        ..style = style ?? PaintingStyle.stroke
        ..strokeWidth = width ?? 12.0;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}