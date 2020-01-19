import 'dart:async';

import 'package:analog_clock/utils/constants.dart';
import 'package:flutter/material.dart';

class ThunderstormEffect extends StatefulWidget {
  final Duration timeDuration;
  const ThunderstormEffect({Key key, this.timeDuration}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ThunderstormEffectState();
}

class ThunderstormEffectState extends State<ThunderstormEffect> {

  Timer _weatherTimer;
  bool _showWeatherCondition = false;
  double _opacity = 0.0;
  Color _skyColor = NIGHT_DARK_BLUE;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          opacity: _showWeatherCondition ? _opacity:0.0,
          child: Container(
            color: _showWeatherCondition ? _skyColor:NIGHT_DARK_BLUE,
          ),
          duration: Duration(milliseconds: 100),
        ),
        AnimatedOpacity(
          opacity: _showWeatherCondition ? _opacity:0.0,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/thunderstorm.png",
              fit: BoxFit.cover,
            ),
          ),
          duration: Duration(milliseconds: 100),
        ),
      ],
    );
  }


  @override
  void initState() {
    super.initState();
    _runWeatherTimer();
  }

  @override
  void dispose() {
    _weatherTimer?.cancel();
    super.dispose();
  }

  void _runWeatherTimer() {
    new Timer.periodic(widget.timeDuration, (Timer t) {
      _weatherTimer = Timer(
        Duration(seconds: 4),
            (){
          _showWeatherCondition = true;
          _skyColor = DAY_LIGHT_BLUE;
          _opacity = 0.8;
          new Timer(Duration(milliseconds: 100), () {
            _showWeatherCondition = false;
            _skyColor = NIGHT_DARK_BLUE;
            new Timer(Duration(milliseconds: 100), () {
              _showWeatherCondition = true;
              _opacity = 0.6;
              _skyColor = DAY_LIGHT_BLUE;
              new Timer(Duration(milliseconds: 100), () {
                _showWeatherCondition = false;
                _skyColor = NIGHT_DARK_BLUE;
              });
            });
          });
        },
      );
    });
  }
}