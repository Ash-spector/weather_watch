import 'package:flutter/material.dart';

/// Returns the correct Lottie animation path based on weather condition and time (day/night).
String getWeatherAnimationAsset(String condition, bool isDay) {
  condition = condition.toLowerCase();

  if (condition.contains('clear')) {
    return isDay
        ? 'assets/animations/clear.json'
        : 'assets/animations/clear_night.json';
  } else if (condition.contains('cloud')) {
    return isDay
        ? 'assets/animations/cloudy.json'
        : 'assets/animations/cloudy_night.json';
  } else if (condition.contains('rain') || condition.contains('drizzle')) {
    return 'assets/animations/rain.json';
  } else {
    // Fallback to clear animation
    return isDay
        ? 'assets/animations/clear.json'
        : 'assets/animations/clear_night.json';
  }
}
