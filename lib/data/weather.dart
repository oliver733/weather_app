import 'dart:convert';
import 'package:weather_app/data/weather_model.dart';
import 'package:weather_app/models/location_model.dart';
import 'package:http/http.dart' as http;
import '../api.dart';

const forecastOpenWeatherMapUrl =
    'https://api.openweathermap.org/data/2.5/forecast';

const nowOpenWeatherMapUrl = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherClass {
  Future<AllWeather> getWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    Map<String, dynamic> forecastMap = await NetworkHelper(
            '$forecastOpenWeatherMapUrl?lat=${location.latitude}&lon=${location.longitude}&appid=${MyKeys.weatherApiKey}&units=metric')
        .getData();

    Map<String, dynamic> nowMap = await NetworkHelper(
            '$nowOpenWeatherMapUrl?lat=${location.latitude}&lon=${location.longitude}&appid=${MyKeys.weatherApiKey}&units=metric')
        .getData();

    return AllWeather.fromJsons(forecastJson: forecastMap, nowJson: nowMap);
  }
}

class NetworkHelper {
  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
