import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../services/weather_service.dart';
import '../utils/weather_animation_mapper.dart';
import '../utils/weather_background_mapper.dart';
import '../widgets/forecast_tile.dart';
import '../widgets/hourly_forecast_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  late Future<WeatherData> _weatherData;
  late Future<List<Map<String, dynamic>>> _forecastData;
  late Future<List<Map<String, String>>> _hourlyData;
  final String city = 'Hamirpur';

  @override
  void initState() {
    super.initState();
    _refreshWeather();
  }

  void _refreshWeather() {
    setState(() {
      _weatherData = _weatherService.fetchWeather(city);
      _forecastData = _weatherService.fetchFiveDayForecast(city);
      _hourlyData = _weatherService.fetchTodayHourlyForecast(city);
    });
  }

  String getAlertMessage(String condition) {
    if (condition.toLowerCase().contains('rain')) {
      return '⚠️ Carry an umbrella!';
    } else if (condition.toLowerCase().contains('clear')) {
      return '☀️ Stay hydrated!';
    } else if (condition.toLowerCase().contains('cloud')) {
      return '☁️ Might be a gloomy day.';
    } else {
      return '🔔 Stay safe out there!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherData>(
      future: _weatherData,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final weather = snapshot.data!;
        final animationAsset = getWeatherAnimationAsset(weather.condition, weather.isDay);
        final now = DateTime.now();
        final alertMessage = getAlertMessage(weather.condition);

        return Scaffold(
          backgroundColor: getWeatherBackground(weather.condition, weather.isDay),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => _refreshWeather(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    /// 🔼 Weather Animation
                    Lottie.asset(
                      animationAsset,
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
                    ),

                    /// 📅 Date
                    Text(
                      DateFormat('EEE, d MMM y').format(now),
                      style: const TextStyle(fontSize: 16, color: Colors.white70),
                    ),

                    /// 🕒 Time
                    Text(
                      DateFormat('hh:mm a').format(now),
                      style: const TextStyle(fontSize: 14, color: Colors.white54),
                    ),

                    const SizedBox(height: 6),

                    /// 📍 City
                    Text(
                      weather.city,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// 🌡️ Temp & Condition
                    Text(
                      '${weather.temperature.toStringAsFixed(1)}°C | ${weather.condition}',
                      style: const TextStyle(fontSize: 18, color: Colors.white70),
                    ),

                    const SizedBox(height: 6),

                    /// 💧 Weather details
                    Text(
                      'Humidity: ${weather.humidity}%, Wind: ${weather.windSpeed} m/s, Pressure: ${weather.pressure} hPa',
                      style: const TextStyle(fontSize: 14, color: Colors.white54),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    /// 🔔 Alert
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        alertMessage,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),

                    /// 🕐 Hourly Forecast
                    const Text("Today's Forecast", style: TextStyle(fontSize: 18, color: Colors.white)),
                    const SizedBox(height: 8),
                    FutureBuilder<List<Map<String, String>>>(
                      future: _hourlyData,
                      builder: (context, hourlySnapshot) {
                        if (!hourlySnapshot.hasData) return const CircularProgressIndicator();
                        return SizedBox(
                          height: 110,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: hourlySnapshot.data!.length,
                            itemBuilder: (context, index) {
                              final hour = hourlySnapshot.data![index];
                              return HourlyForecastTile(
                                time: hour['time']!,
                                temp: hour['temp']!,
                                condition: hour['condition']!,
                              );
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    /// 📅 5-Day Forecast
                    const Text('Next 5 Days', style: TextStyle(fontSize: 18, color: Colors.white)),
                    const SizedBox(height: 8),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _forecastData,
                      builder: (context, forecastSnapshot) {
                        if (!forecastSnapshot.hasData) return const CircularProgressIndicator();
                        return Column(
                          children: forecastSnapshot.data!
                              .map((day) => ForecastTile(
                            day: day['day'],
                            temp: day['temp'],
                            condition: day['condition'],
                          ))
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
