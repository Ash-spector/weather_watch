import 'package:flutter/material.dart';

Color getWeatherBackground(String condition, bool isDay) {
  condition = condition.toLowerCase();

  if (condition.contains('clear')) {
    return isDay ? Colors.lightBlue.shade300 : Colors.indigo.shade900;
  } else if (condition.contains('cloud')) {
    return isDay ? Colors.blueGrey.shade300 : Colors.grey.shade800;
  } else if (condition.contains('rain')) {
    return Colors.blueGrey.shade700;
  } else if (condition.contains('snow')) {
    return Colors.blue.shade100;
  } else {
    return Colors.grey.shade900;
  }
}
