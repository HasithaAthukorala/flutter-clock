// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:analog_clock/background/tween.dart';
import 'package:analog_clock/clock/clock_dial_painter.dart';
import 'package:analog_clock/clock/weather_widget.dart';
import 'package:analog_clock/utils/slider_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import '../background/fancy_background.dart';
import '../background/wave.dart';
import 'drawn_hand.dart';

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  final ClockModel model;

  const AnalogClock(this.model);

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _condition = '';
  Timer _timer;

  final tween = MultiTrackTween([
    Track("color1").add(Duration(seconds: 3),
        ColorTween(begin: Color(0xffD38312), end: Colors.lightBlue.shade900)),
    Track("color2").add(Duration(seconds: 3),
        ColorTween(begin: Color(0xffA83279), end: Colors.blue.shade600))
  ]);

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].

    Size size = MediaQuery.of(context).size;

    final time = DateFormat.Hms().format(DateTime.now());
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: Color(0xFF0F3F63),
        child: Stack(
          children: [
            onBottom(AnimatedWave(
              height: 30,
              speed: 1.0,
            )),
            onBottom(AnimatedWave(
              height: 40,
              speed: 0.9,
              offset: pi,
            )),
            onBottom(AnimatedWave(
              height: 80,
              speed: 1.2,
              offset: pi / 2,
            )),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                  flex: 8,
                  child: WeatherWidget(
                      temperature: _temperature, condition: _condition),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        VerticalDivider(
                          color: Colors.white.withOpacity(0.4),
                          thickness: 0.5,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Stack(
                    children: <Widget>[
                      new Center(
                        child: Container(
                          child: CustomPaint(
                            painter: SliderPainter(
                                startAngle: 0,
                                endAngle:
                                    ((_now.millisecond * 0.001) + _now.second) *
                                        radiansPerTick,
                                sweepAngle: 300,
                                selectionColor: Color(0xa11C9CF6),
                                radius: 105,
                                strokeWidth: 2),
                          ),
                        ),
                      ),
                      new Center(
                        child: Container(
                          child: CustomPaint(
                            painter: SliderPainter(
                                startAngle: 0,
                                endAngle:
                                    ((_now.millisecond * 0.001) + _now.second) *
                                        radiansPerTick,
                                sweepAngle: 300,
                                selectionColor: Color(0xa11C9CF6),
                                radius: 120,
                                strokeWidth: 12),
                          ),
                        ),
                      ),
                      DrawnHand(
                        color: Color(0xc1ff6781),
                        thickness: 8,
                        size: 0.65,
                        angleRadians: _now.minute * radiansPerTick,
                      ),
                      DrawnHand(
                        color: Color(0xc1ff6781),
                        thickness: 16,
                        size: 0.4,
                        angleRadians: _now.hour * radiansPerTick,
                      ),
                      DrawnHand(
                        color: Colors.white60,
                        thickness: 4,
                        size: 0.7,
                        angleRadians: _now.second * radiansPerTick,
                      ),
                      new Center(
                        child: Container(
                          child: CustomPaint(
                            painter: ClockDialPainter(size, _now.second),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [animation["color1"], animation["color2"]])),
        );
      },
    );
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  onBottom(Widget child) => Positioned.fill(
          child: Align(
        alignment: Alignment.bottomCenter,
        child: child,
      ));

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _condition = widget.model.weatherString;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(microseconds: 100) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }
}
