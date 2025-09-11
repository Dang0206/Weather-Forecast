import 'package:flutter/material.dart';
import 'package:web_forecast_weather/models/forecast_info.dart';
import 'package:web_forecast_weather/models/location_item.dart';
import 'package:flutter/material.dart';
import 'package:web_forecast_weather/services/api_service.dart';
import 'package:flutter/material.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherService _service = WeatherService();

  // Trạng thái
  ForecastInfo? _currentWeather;
  List<ForecastInfo> _forecastList = [];
  bool _isLoading = false;
  String? _error;

  // Thành phố hiện tại
  String? _selectedCity;

  // Getters
  ForecastInfo? get currentWeather => _currentWeather;
  List<ForecastInfo> get forecastList => _forecastList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCity => _selectedCity;

  /// Chọn thành phố và tự động fetch dữ liệu
  void selectCity(String city) {
    _selectedCity = city;
    fetchWeather(city);
    notifyListeners();
  }

  /// Lấy dữ liệu thời tiết theo tên thành phố
  Future<void> fetchWeather(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.fetchWeather(city);

      // Lấy current
      _currentWeather = ForecastInfo.fromCurrentJson(data['current']);

      // Lấy forecast 7 ngày
      final forecastDays = data['forecast']['forecastday'] as List;
      _forecastList = forecastDays
          .map((json) => ForecastInfo.fromForecastJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Lấy dữ liệu thời tiết theo tọa độ
  Future<void> fetchWeatherByCoordinates(double lat, double lon) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.fetchWeatherByCoordinates(lat, lon);

      // Lấy current
      _currentWeather = ForecastInfo.fromCurrentJson(data['current']);

      // Lấy forecast 7 ngày
      final forecastDays = data['forecast']['forecastday'] as List;
      _forecastList = forecastDays
          .map((json) => ForecastInfo.fromForecastJson(json))
          .toList();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Clear dữ liệu
  void clear() {
    _currentWeather = null;
    _forecastList = [];
    _selectedCity = null;
    _error = null;
    notifyListeners();
  }
}
