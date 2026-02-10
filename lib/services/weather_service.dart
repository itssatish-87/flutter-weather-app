import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  Future<Weather> fetchWeather(String city) async {
    final geoUrl = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$city',
    );
    final geoRes = await http.get(geoUrl);
    final geoData = json.decode(geoRes.body);

    final lat = geoData['results'][0]['latitude'];
    final lon = geoData['results'][0]['longitude'];

    final weatherUrl = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true',
    );

    final response = await http.get(weatherUrl);
    final data = json.decode(response.body);

    return Weather(
      temperature: data['current_weather']['temperature'],
      windSpeed: data['current_weather']['windspeed'],
      weatherCode: data['current_weather']['weathercode'],
    );
  }
}
