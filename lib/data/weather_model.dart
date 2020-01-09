import 'package:flutter/material.dart';

class AllWeather {
  final String city;
  final Weather nowWeather;
  final DayWeather day1;
  final DayWeather day2;
  final DayWeather day3;
  final DayWeather day4;
  final DayWeather day5;

  AllWeather({
    @required this.city,
    @required this.nowWeather,
    @required this.day1,
    @required this.day2,
    @required this.day3,
    @required this.day4,
    @required this.day5,
  });

  factory AllWeather.fromJsons({
    @required Map<String, dynamic> forecastJson,
    @required Map<String, dynamic> nowJson,
  }) {
    String city = forecastJson['city']['name'];

    Weather nowWeather = Weather.fromJson(nowJson);

    List<Weather> day1 = [];
    List<Weather> day2 = [];
    List<Weather> day3 = [];
    List<Weather> day4 = [];
    List<Weather> day5 = [];

    for (var i = 0; i < 40; i++) {
      List<dynamic> per3hourWeatherMap = forecastJson['list'];
      Weather weather = Weather.fromJson(per3hourWeatherMap[i]);
      if (i < 8) {
        day1.add(weather);
      } else if (i < 16) {
        day2.add(weather);
      } else if (i < 24) {
        day3.add(weather);
      } else if (i < 32) {
        day4.add(weather);
      } else if (i < 40) {
        day5.add(weather);
      }
    }
    return AllWeather(
      day1: DayWeather.fromWeatherList(day1),
      day2: DayWeather.fromWeatherList(day2),
      day3: DayWeather.fromWeatherList(day3),
      day4: DayWeather.fromWeatherList(day4),
      day5: DayWeather.fromWeatherList(day5),
      nowWeather: nowWeather,
      city: city,
    );
  }
}

class DayWeather {
  final List<Weather> weatherList;
  final String temperature;
  final String weatherIcon;

  DayWeather({
    @required this.temperature,
    @required this.weatherIcon,
    @required this.weatherList,
  });

  factory DayWeather.fromWeatherList(List<Weather> weatherList) {
    double averageDayTemperature = 0;
    double averageCondition = 0;
    weatherList.forEach((weather) {
      averageDayTemperature += weather.temp;
      averageCondition += weather.condition;
    });

    return DayWeather(
        weatherList: weatherList,
        temperature: '${(averageDayTemperature / 8).round().toString()} °C',
        weatherIcon: getWeatherIcon((averageCondition / 8).round()));
  }
}

class Weather {
  final int condition;
  final DateTime time;
  final double temp;
  final String temperature;
  final String weatherIcon;

  Weather({
    @required this.condition,
    @required this.temp,
    @required this.time,
    @required this.temperature,
    @required this.weatherIcon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    int timeStamp = json['dt'];
    DateTime finalTime = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    double temp = json['main']['temp'];
    String finalTemp = '${temp.round().toString()} °C';
    int condition = json['weather'][0]['id'];

    return Weather(
        condition: condition,
        temp: temp,
        time: finalTime,
        temperature: finalTemp,
        weatherIcon: getWeatherIcon(condition));
  }
}

String getWeatherIcon(int condition) {
  String weatherIcon = '';
  if (condition < 300) {
    weatherIcon = '🌩';
  } else if (condition < 400) {
    weatherIcon = '🌧';
  } else if (condition < 600) {
    weatherIcon = '☔️';
  } else if (condition < 700) {
    weatherIcon = '☃️';
  } else if (condition < 800) {
    weatherIcon = '🌫';
  } else if (condition == 800) {
    weatherIcon = '☀️';
  } else if (condition <= 804) {
    weatherIcon = '☁️';
  } else {
    weatherIcon = '';
  }
  return weatherIcon;
}

// String getMessage(int temp) {
//   if (temp > 25) {
//     return 'Sunny';
//   } else if (temp > 20) {
//     return 'Warm';
//   } else if (temp < 10) {
//     return 'Cold';
//   } else {
//     return '..';
//   }
// }
