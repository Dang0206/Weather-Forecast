import 'package:flutter/material.dart';
import 'package:web_forecast_weather/models/forecast_info.dart';
import 'package:web_forecast_weather/services/api_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _service = WeatherService();

  ForecastInfo? _currentWeather;
  List<ForecastInfo> _forecastList = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedCity;

  final List<SearchHistoryItem> _searchHistory = [];
  List<SearchHistoryItem> get searchHistory =>
      List.unmodifiable(_searchHistory);

  WeatherProvider() {
    _loadHistory();
  }

  ForecastInfo? get currentWeather => _currentWeather;
  List<ForecastInfo> get forecastList => _forecastList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCity => _selectedCity;

  void selectCity(String city) {
    _selectedCity = city;
    fetchWeather(city);
    notifyListeners();
  }

  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.fetchWeather(city);

      _currentWeather = ForecastInfo.fromCurrentJson(data['current']);
      final forecastDays = data['forecast']['forecastday'] as List;
      _forecastList = forecastDays
          .map((json) => ForecastInfo.fromForecastJson(json))
          .toList();

      if (_currentWeather != null) {
        final item = SearchHistoryItem(
          city: _selectedCity ?? "Unknown",
          weather: _currentWeather!,
        );
        _searchHistory.add(item);
        _saveHistory();
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final today = DateTime.now();
    final todayKey = "${today.year}-${today.month}-${today.day}";

    final historyJson = _searchHistory.map((e) => e.toJson()).toList();

    await prefs.setString("history_date", todayKey);
    await prefs.setString("search_history", jsonEncode(historyJson));
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString("history_date");
    final savedHistory = prefs.getString("search_history");

    final today = DateTime.now();
    final todayKey = "${today.year}-${today.month}-${today.day}";

    if (savedDate == todayKey && savedHistory != null) {
      final List decoded = jsonDecode(savedHistory);
      _searchHistory.clear();
      _searchHistory.addAll(
        decoded.map((e) => SearchHistoryItem.fromJson(e)),
      );
    } else {
      _searchHistory.clear();
      await prefs.remove("search_history");
    }

    notifyListeners();
  }
}

class SearchHistoryItem {
  final String city;
  final ForecastInfo weather;

  SearchHistoryItem({
    required this.city,
    required this.weather,
  });

  Map<String, dynamic> toJson() {
    return {
      "city": city,
      "weather": weather.toJsonFromCurrent(),
    };
  }

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      city: json["city"],
      weather: ForecastInfo.fromCurrentJson(json["weather"]),
    );
  }
}
