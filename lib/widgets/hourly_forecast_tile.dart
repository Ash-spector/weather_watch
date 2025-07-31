import 'package:flutter/material.dart';

class HourlyForecastTile extends StatelessWidget {
  final String time;
  final String temp;
  final String condition;

  const HourlyForecastTile({
    Key? key,
    required this.time,
    required this.temp,
    required this.condition,
  }) : super(key: key);

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
        return Icons.blur_on;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getWeatherIcon(condition),
            size: 20,
            color: Colors.orangeAccent,
          ),
          const SizedBox(height: 6),
          Text(time, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Text(temp, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
