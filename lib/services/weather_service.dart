import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/model/weather_model.dart';

class WetaherService {
  // ignore: constant_identifier_names
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WetaherService({required this.apiKey});

  Future<Weather> getWeather(String cityName) async {
    final parse = '$BASE_URL?q=$cityName&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(parse));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ошибка загрузки погоды');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    );

    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placemark[0].locality;
    return city ?? ' ';
  }
}
