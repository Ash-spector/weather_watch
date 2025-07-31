import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ForecastTile extends StatelessWidget {
  final String day;
  final String temp;
  final String condition;

  const ForecastTile({
    Key? key,
    required this.day,
    required this.temp,
    required this.condition,
  }) : super(key: key);

  IconData getWeatherIcon(String condition) {
    final lower = condition.toLowerCase();

    if (lower.contains('clear')) return Icons.wb_sunny;
    if (lower.contains('cloud')) return Icons.cloud;
    if (lower.contains('rain')) return Icons.umbrella;
    if (lower.contains('snow')) return Icons.ac_unit;
    if (lower.contains('thunder')) return Icons.flash_on;
    if (lower.contains('mist') || lower.contains('fog') || lower.contains('haze')) return Icons.blur_on;

    return Icons.help_outline; // fallback
  }

  @override
  Widget build(BuildContext context) {
    // Convert date string to weekday
    String weekdayName;
    try {
      final date = DateTime.parse(day);
      weekdayName = DateFormat('E').format(date); // Short day like "Mon"
    } catch (e) {
      weekdayName = day;
    }

    final icon = getWeatherIcon(condition);

    return Card(
      color: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: Colors.orange.shade700, size: 28),
        title: Text(
          weekdayName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          condition,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        trailing: Text(
          '$temp°C',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
