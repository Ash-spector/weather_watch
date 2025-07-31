import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '9f8070f1cc4738ab8193460ab6c3efa0'; // 🔐 Replace with your OpenWeatherMap API key

  Future<WeatherData> fetchWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherData.fromJson(data);
    } else {
      throw Exception('Failed to load current weather');
    }
  }

  Future<List<Map<String, dynamic>>> fetchFiveDayForecast(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Map<String, dynamic>> forecast = [];

      final Map<String, bool> addedDays = {};
      for (var item in data['list']) {
        final dateTime = DateTime.parse(item['dt_txt']);
        final dayName = _getShortWeekday(dateTime.weekday);

        if (!addedDays.containsKey(dayName) && dateTime.hour == 12) {
          forecast.add({
            'day': dayName,
            'temp': item['main']['temp'].toStringAsFixed(1),
            'condition': item['weather'][0]['main'],
          });
          addedDays[dayName] = true;
        }

        if (forecast.length >= 5) break;
      }

      return forecast;
    } else {
      throw Exception('Failed to load 5-day forecast');
    }
  }

  Future<List<Map<String, String>>> fetchTodayHourlyForecast(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final today = DateTime.now().day;
      final List<Map<String, String>> hourlyData = [];

      for (var item in data['list']) {
        final dateTime = DateTime.parse(item['dt_txt']);
        if (dateTime.day == today) {
          final hour = _formatHour(dateTime);
          hourlyData.add({
            'time': hour,
            'temp': item['main']['temp'].toStringAsFixed(1) + '°C',
            'condition': item['weather'][0]['main'],
          });
        }

        if (hourlyData.length >= 8) break; // Limit to next 8 readings
      }

      return hourlyData;
    } else {
      throw Exception('Failed to load hourly forecast');
    }
  }

  String _formatHour(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:00';
  }

  String _getShortWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
}

class WeatherData {
  final String city;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final bool isDay; // ✅ Added to support day/night animations

  WeatherData({
    required this.city,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.isDay,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      pressure: json['main']['pressure'],
      isDay: json['weather'][0]['icon'].contains('d'), // 🌞 if icon has 'd'
    );
  }
}
