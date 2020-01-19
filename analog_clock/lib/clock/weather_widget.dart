import 'dart:async';

import 'package:analog_clock/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherWidget extends StatefulWidget {
  final String temperature;
  final String condition;

  const WeatherWidget({Key key, this.temperature, this.condition})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => WeatherWidgetState();
}

class WeatherWidgetState extends State<WeatherWidget>
    with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  List weekdays = ["Mon", "Tue", "Wed", "Thurs", "Fri", "Sat", "Sun"];

  @override
  Widget build(BuildContext context) {
    return _getWeatherWidget();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    _runTimer();
  }

  IconData _getWeatherIcon() {
    int hour = DateTime.now().hour;
    if (hour >= 0 && hour < 18) {
      switch (widget.condition) {
        case CLOUDY:
          return WeatherIcons.day_cloudy;
        case FOGGY:
          return WeatherIcons.day_fog;
        case RAINY:
          return WeatherIcons.day_rain;
        case SNOWY:
          return WeatherIcons.day_snow;
        case SUNNY:
          return WeatherIcons.day_sunny;
        case THUNDERSTORM:
          return WeatherIcons.day_thunderstorm;
        case WINDY:
          return WeatherIcons.day_windy;
        default:
          return WeatherIcons.cloudy;
      }
    } else {
      switch (widget.condition) {
        case CLOUDY:
          return WeatherIcons.night_cloudy;
        case FOGGY:
          return WeatherIcons.night_fog;
        case RAINY:
          return WeatherIcons.night_rain;
        case SNOWY:
          return WeatherIcons.night_snow;
        case SUNNY:
          return WeatherIcons.day_sunny;
        case THUNDERSTORM:
          return WeatherIcons.night_thunderstorm;
        case WINDY:
          return WeatherIcons.night_cloudy_windy;
        default:
          return WeatherIcons.cloudy;
      }
    }
  }

  Widget _getWeatherWidget() {
    _scale = 1 - _controller.value;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Transform.scale(
                scale: _scale,
                child: BoxedIcon(
                  _getWeatherIcon(),
                  size: 50,
                  color: Color(0xD1FFEB3B),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    widget.temperature,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    '${DateTime.now().day} / ${DateTime.now().month}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 1,
                      height: 15,
                      child: Container(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 1,
                      height: 15,
                      child: Container(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    (widget.condition.toLowerCase().contains("thunderstorm"))
                        ? "T'storm"
                        : '${widget.condition[0].toUpperCase()}${widget.condition.substring(1)}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    weekdays[DateTime.now().weekday - 1],
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _runTimer() {
    const time = const Duration(seconds: 30);
    new Timer.periodic(time, (Timer t) {
      _controller.forward();
      new Timer(Duration(milliseconds: 500), () {
        _controller.reverse();
      });
    });
  }
}
