import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherApiService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = 'c5a03ce3b5da4a7c23cf423694cea014';

  Future<Weather> getWeather(String cityName) async {
    try {
      print('🌐 Запрос погоды для города: $cityName');
      
      final url = '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric&lang=ru';
      print('🔗 URL: $url');
      
      final response = await http.get(Uri.parse(url));
      print('📊 Статус ответа: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Успешный ответ от API
        final data = json.decode(response.body);
        print('✅ Успешно получены реальные данные от API');
        return _parseWeatherData(data);
      } else if (response.statusCode == 401) {
        throw Exception('Ошибка авторизации API. Проверьте API ключ.');
      } else if (response.statusCode == 404) {
        throw Exception('Город "$cityName" не найден. Проверьте название.');
      } else if (response.statusCode == 429) {
        throw Exception('Превышен лимит запросов. Попробуйте позже.');
      } else {
        throw Exception('Ошибка сервера: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Ошибка при запросе: $e');
      rethrow;
    }
  }

  // Парсинг реальных данных от API
  Weather _parseWeatherData(Map<String, dynamic> data) {
    try {
      return Weather(
        cityName: data['name'] ?? 'Неизвестный город',
        temperature: _parseTemperature(data),
        description: _parseDescription(data),
        humidity: _parseHumidity(data),
        windSpeed: _parseWindSpeed(data),
        lastUpdated: DateTime.now(),
        iconCode: _parseIconCode(data),
      );
    } catch (e) {
      print('❌ Ошибка парсинга данных: $e');
      throw Exception('Ошибка обработки данных о погоде');
    }
  }

  double _parseTemperature(Map<String, dynamic> data) {
    try {
      if (data['main'] != null && data['main']['temp'] != null) {
        return data['main']['temp'].toDouble();
      }
      throw Exception('Температура не найдена');
    } catch (e) {
      print('⚠️ Ошибка парсинга температуры: $e');
      return 0.0;
    }
  }

  String _parseDescription(Map<String, dynamic> data) {
    try {
      if (data['weather'] != null && 
          data['weather'] is List && 
          data['weather'].isNotEmpty) {
        return data['weather'][0]['description'] ?? 'Нет данных';
      }
      return 'Нет данных';
    } catch (e) {
      print('⚠️ Ошибка парсинга описания: $e');
      return 'Нет данных';
    }
  }

  int _parseHumidity(Map<String, dynamic> data) {
    try {
      if (data['main'] != null && data['main']['humidity'] != null) {
        return data['main']['humidity'].toInt();
      }
      return 0;
    } catch (e) {
      print('⚠️ Ошибка парсинга влажности: $e');
      return 0;
    }
  }

  double _parseWindSpeed(Map<String, dynamic> data) {
    try {
      if (data['wind'] != null && data['wind']['speed'] != null) {
        return data['wind']['speed'].toDouble();
      }
      return 0.0;
    } catch (e) {
      print('⚠️ Ошибка парсинга скорости ветра: $e');
      return 0.0;
    }
  }

  String _parseIconCode(Map<String, dynamic> data) {
    try {
      if (data['weather'] != null && 
          data['weather'] is List && 
          data['weather'].isNotEmpty &&
          data['weather'][0]['icon'] != null) {
        return data['weather'][0]['icon'];
      }
      return '01d'; // Иконка по умолчанию
    } catch (e) {
      print('⚠️ Ошибка парсинга иконки: $e');
      return '01d';
    }
  }

  // Получение URL иконки погоды
  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}