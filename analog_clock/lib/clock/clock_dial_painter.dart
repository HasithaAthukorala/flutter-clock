import 'dart:math';

import 'package:flutter/material.dart';

class ClockDialPainter extends CustomPainter {


  final hourTickMarkLength = 10.0;
  final minuteTickMarkLength = 5.0;

  final hourTickMarkWidth = 3.0;
  final minuteTickMarkWidth = 1.5;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  final double tickLength = 8.0;
  final double tickWidth = 3.0;

  final Size screenSize;
  final tickCount = 60;
  int currentSecond;

  final romanNumeralList = [
    'XII',
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    'XI'
  ];

  ClockDialPainter(this.screenSize, this.currentSecond)
      : tickPaint = new Paint(),
        textPainter = new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        textStyle = const TextStyle(
          color: Colors.black,
          fontFamily: 'Times New Roman',
          fontSize: 15.0,
        ) {
    tickPaint.color = Colors.white38;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final angle = 2 * pi / tickCount;
    final radius = screenSize.shortestSide * 0.5 * 0.56;
    canvas.save();

    // drawing
//    canvas.translate(dx, dy);
    for (var i = 0; i < tickCount; i++) {
      //make the length and stroke of the tick marker longer and thicker depending
      if (i <= currentSecond) {
        tickPaint.color = Colors.white38;
      } else {
        tickPaint.color = Colors.white10;
      }
      if (i == 0 || i == 15 || i == 30 || i == 45) {
        tickPaint.color = Color(0x81ff6781);
      }
      if (i == 5 || i == 10 || i == 20 || i == 25 || i == 35 || i == 40 || i == 50 || i == 55) {
        tickPaint.color = Color(0x51ff6781);
      }
      tickMarkLength = tickLength;
      tickPaint.strokeWidth =
          tickWidth;
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
