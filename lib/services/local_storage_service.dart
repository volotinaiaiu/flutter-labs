import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather.dart';

class LocalStorageService {
  static const String _prefsKey = 'last_city';
  static const String _weatherHistoryKey = 'weather_history';
  static const String _habitWeatherKey = 'habit_weather';

  // Сохранение погоды в историю
  Future<void> saveWeatherToHistory(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getWeatherHistory();
    
    // Добавляем новую запись в начало
    history.insert(0, weather);
    
    // Сохраняем только последние 10 записей
    final limitedHistory = history.take(10).toList();
    
    final historyJson = limitedHistory.map((w) => w.toMap()).toList();
    await prefs.setString(_weatherHistoryKey, json.encode(historyJson));
  }

  // Получение истории погоды
  Future<List<Weather>> getWeatherHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString(_weatherHistoryKey);
    
    if (historyJson != null) {
      try {
        final List<dynamic> historyList = json.decode(historyJson);
        return historyList.map((item) => Weather.fromMap(item)).toList();
      } catch (e) {
        print('Ошибка загрузки истории погоды: $e');
      }
    }
    return [];
  }

  // Сохранение последнего города в SharedPreferences
  Future<void> saveLastCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, cityName);
  }

  // Получение последнего города
  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsKey);
  }

  // Очистка истории
  Future<void> clearWeatherHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weatherHistoryKey);
  }

  // Сохранение связи привычки с погодой
  Future<void> saveHabitWeather(String habitId, Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    final habitWeatherMap = await _getHabitWeatherMap();
    
    habitWeatherMap[habitId] = {
      'weather': weather.toMap(),
      'created_at': DateTime.now().toIso8601String(),
    };
    
    await prefs.setString(_habitWeatherKey, json.encode(habitWeatherMap));
  }

  // Получение погоды для привычки
  Future<Weather?> getHabitWeather(String habitId) async {
    final habitWeatherMap = await _getHabitWeatherMap();
    final data = habitWeatherMap[habitId];
    
    if (data != null) {
      try {
        return Weather.fromMap(data['weather']);
      } catch (e) {
        print('Ошибка загрузки погоды для привычки: $e');
      }
    }
    return null;
  }

  // Вспомогательный метод для получения карты привычка-погода
  Future<Map<String, dynamic>> _getHabitWeatherMap() async {
    final prefs = await SharedPreferences.getInstance();
    final habitWeatherJson = prefs.getString(_habitWeatherKey);
    
    if (habitWeatherJson != null) {
      try {
        return Map<String, dynamic>.from(json.decode(habitWeatherJson));
      } catch (e) {
        print('Ошибка загрузки карты привычка-погода: $e');
      }
    }
    return {};
  }
}