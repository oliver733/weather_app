import 'dart:convert';

import 'package:weather_app/models/location_model.dart';
import 'package:http/http.dart' as http;
import '../api.dart';

const openWeatherMapUrl = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapUrl?q=$cityName&appid=${MyKeys.weatherApiKey}&units=metric');
    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$openWeatherMapUrl?lat=${location.latitude}&lon=${location.longitude}&appid=${MyKeys.weatherApiKey}&units=metric');

    var weatherData = await networkHelper.getData();
    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'Sunny';
    } else if (temp > 20) {
      return 'Warm';
    } else if (temp < 10) {
      return 'Cold';
    } else {
      return '..';
    }
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
