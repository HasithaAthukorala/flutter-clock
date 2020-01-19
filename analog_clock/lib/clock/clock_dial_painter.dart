import 'dart:math';

import 'package:flutter/material.dart';

class ClockDialPainter extends CustomPainter {

  final Paint tickPaint;

  final double tickLength = 8.0;
  final double tickWidth = 3.0;

  final Size screenSize;
  final tickCount = 60;
  int currentSecond;
  final ThemeData customTheme;

  ClockDialPainter(this.screenSize, this.currentSecond, this.customTheme)
      : tickPaint = new Paint() {
    tickPaint.color = Colors.white38;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final angle = 2 * pi / tickCount;
    final radius = screenSize.shortestSide * 0.5 * 0.56;
    canvas.save();

    // drawing
    for (var i = 0; i < tickCount; i++) {
      //make the length and stroke of the tick marker longer and thicker depending
      if (i <= currentSecond) {
        tickPaint.color = customTheme.highlightColor.withOpacity(0.5);
      } else {
        tickPaint.color = customTheme.highlightColor.withOpacity(0.2);
      }
      if (i == 0 || i == 15 || i == 30 || i == 45) {
        tickPaint.color = customTheme.accentColor.withOpacity(0.6);
      }
      if (i == 5 ||
          i == 10 ||
          i == 20 ||
          i == 25 ||
          i == 35 ||
          i == 40 ||
          i == 50 ||
          i == 55) {
        tickPaint.color = customTheme.accentColor.withOpacity(0.3);
      }
      tickMarkLength = tickLength;
      tickPaint.strokeWidth = tickWidth;
      canvas.drawLine(new Offset(0.0, -radius),
          new Offset(0.0, -radius + tickMarkLength), tickPaint);

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
