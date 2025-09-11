import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_forecast_weather/models/forecast_info.dart';
import 'package:web_forecast_weather/providers/location.dart';

class ForecastCard extends StatelessWidget {
  final ForecastInfo forecast;

  const ForecastCard({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[700],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "(${forecast.date ?? 'N/A'})",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Image.network(
    "https:${forecast.condition.icon}", 
    width: 36,
    height: 36,
  ),
          Text(
            "Temp: ${forecast.tempC}°C",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            "Wind: ${forecast.windKph} KPH",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            "Humidity: ${forecast.humidity}%",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
