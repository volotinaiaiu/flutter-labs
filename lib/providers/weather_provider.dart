import 'package:flutter/foundation.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';
import '../services/local_storage_service.dart';

class WeatherProvider with ChangeNotifier {
  final WeatherApiService _apiService;
  final LocalStorageService _localStorageService;

  WeatherProvider({
    required WeatherApiService apiService,
    required LocalStorageService localStorageService,
  })  : _apiService = apiService,
        _localStorageService = localStorageService;

  // Состояние
  Weather? _currentWeather;
  List<Weather> _weatherHistory = [];
  bool _isLoading = false;
  String _error = '';
  String? _lastCity;

  // Геттеры
  Weather? get currentWeather => _currentWeather;
  List<Weather> get weatherHistory => _weatherHistory;
  bool get isLoading => _isLoading;
  String get error => _error;
  String? get lastCity => _lastCity;

  // Загрузка последнего города
  Future<void> loadLastCity() async {
    _lastCity = await _localStorageService.getLastCity();
    notifyListeners();
  }

  // Получение погоды
  Future<void> fetchWeather(String cityName) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      print('🔄 Запрос погоды для: $cityName');
      final weather = await _apiService.getWeather(cityName);
      
      // Сохраняем в историю и в настройки
      await _localStorageService.saveWeatherToHistory(weather);
      await _localStorageService.saveLastCity(cityName);
      
      _currentWeather = weather;
      await loadWeatherHistory();
      
      print('✅ Погода успешно получена: ${weather.temperature}°C в ${weather.cityName}');
      
    } catch (e) {
      _error = e.toString();
      print('❌ Ошибка получения погоды: $e');
      
      // Информативные сообщения об ошибках
      if (e.toString().contains('Город')) {
        _error = e.toString();
      } else if (e.toString().contains('авторизации')) {
        _error = 'Ошибка API ключа. Проверьте настройки.';
      } else if (e.toString().contains('лимит')) {
        _error = 'Превышен лимит запросов. Попробуйте через минуту.';
      } else if (e.toString().contains('сети')) {
        _error = 'Проблема с интернет-соединением. Проверьте подключение.';
      } else {
        _error = 'Не удалось получить погоду: ${e.toString()}';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Загрузка истории
  Future<void> loadWeatherHistory() async {
    try {
      _weatherHistory = await _localStorageService.getWeatherHistory();
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка загрузки истории: $e';
      notifyListeners();
    }
  }

  // Очистка истории
  Future<void> clearHistory() async {
    try {
      await _localStorageService.clearWeatherHistory();
      _weatherHistory.clear();
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка очистки истории: $e';
      notifyListeners();
    }
  }

  // Получение URL иконки
  String getWeatherIconUrl(String iconCode) {
    return _apiService.getWeatherIconUrl(iconCode);
  }

  // Обновление текущей погоды
  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeather(_currentWeather!.cityName);
    }
  }

  // Сохранение погоды для привычки
  Future<void> saveWeatherForHabit(String habitId) async {
    if (_currentWeather != null) {
      await _localStorageService.saveHabitWeather(habitId, _currentWeather!);
    }
  }

  // Получение погоды для привычки
  Future<Weather?> getWeatherForHabit(String habitId) async {
    return await _localStorageService.getHabitWeather(habitId);
  }

  // Сброс ошибки
  void clearError() {
    _error = '';
    notifyListeners();
  }
}