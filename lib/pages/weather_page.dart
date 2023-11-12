import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService =
      WetaherService(apiKey: 'c0c61605889d068580394c669555cd82');
  Weather? _weather;

  _feachWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  String getWitherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assetssun.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smouke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/could.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'clear':
        return 'assets/sun.json';
      default:
        return 'assets/sun.json';
    }
  }

  @override
  void initState() {
    _feachWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weather?.cityName ?? 'Загрузка погоды',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Lottie.asset(getWitherAnimation(_weather?.mainCondition)),
            Text(
              '${_weather?.temperature.round()} °C',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
