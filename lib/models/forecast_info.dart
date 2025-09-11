
import 'package:flutter/material.dart';
import 'package:web_forecast_weather/models/weather_condition.dart';


class ForecastInfo {
  final String? date;
  final double tempC;
  final double windKph;
  final int humidity;
  final WeatherCondition condition;

  ForecastInfo({
    this.date,
    required this.windKph,
    required this.tempC,
    required this.humidity,
    required this.condition,
  });

  factory ForecastInfo.fromForecastJson(Map<String, dynamic> json) {
    return ForecastInfo(
      date: json['date'],
      tempC: (json['day']['avgtemp_c'] as num).toDouble(),
      windKph: (json['day']['maxwind_kph'] as num).toDouble(),
      humidity: json['day']['avghumidity'],
      condition: WeatherCondition.fromJson(json['day']['condition']),
    );
  }

  factory ForecastInfo.fromCurrentJson(Map<String, dynamic> json) {
    return ForecastInfo(
      tempC: json['temp_c'].toDouble(),
      windKph: json['wind_kph'].toDouble(),
      humidity: json['humidity'],
      condition: WeatherCondition.fromJson(json['condition']),
    );
  }

  Map<String, dynamic> toJsonFromCurrent() {
    return {
      // Include all the same fields used in fromCurrentJson
      'temp_c': tempC,
      'condition': condition.toJson(),
      'wind_kph': windKph,
      'humidity': humidity,
      // Add any other fields as needed
    };
  }
}