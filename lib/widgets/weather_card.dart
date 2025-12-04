import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../screens/weather_screen.dart';

class WeatherCard extends StatelessWidget {
  final bool showFullInfo;
  final bool showDetailsButton; // Новый параметр

  const WeatherCard({
    Key? key, 
    this.showFullInfo = false,
    this.showDetailsButton = true, // По умолчанию показываем кнопку
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(weatherProvider, context),
                const SizedBox(height: 16),
                _buildContent(weatherProvider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(WeatherProvider weatherProvider, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '🌤️ Погода для привычек',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            if (weatherProvider.currentWeather != null)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: weatherProvider.isLoading ? null : weatherProvider.refreshWeather,
                tooltip: 'Обновить',
              ),
            // Показываем кнопку "Подробнее" только если showDetailsButton = true
            if (showDetailsButton)
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WeatherScreen()),
                  );
                },
                tooltip: 'Подробнее',
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(WeatherProvider weatherProvider) {
    if (weatherProvider.isLoading) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Получаем данные о погоде...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (weatherProvider.error.isNotEmpty) {
      return Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          Text(
            weatherProvider.error,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          _buildCityInput(weatherProvider),
        ],
      );
    }

    if (weatherProvider.currentWeather == null) {
      return _buildCityInput(weatherProvider);
    }

    return _buildWeatherInfo(weatherProvider);
  }

  Widget _buildCityInput(WeatherProvider weatherProvider) {
    final cityController = TextEditingController();
    
    if (weatherProvider.lastCity != null) {
      cityController.text = weatherProvider.lastCity!;
    }

    return Column(
      children: [
        TextField(
          controller: cityController,
          decoration: const InputDecoration(
            labelText: 'Введите город для отслеживания погоды',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_city),
            hintText: 'Например: Moscow или Москва',
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            if (cityController.text.trim().isNotEmpty) {
              weatherProvider.fetchWeather(cityController.text.trim());
            }
          },
          child: const Text('Получить погоду'),
        ),
      ],
    );
  }

  Widget _buildWeatherInfo(WeatherProvider weatherProvider) {
    final weather = weatherProvider.currentWeather!;
    
    return Column(
      children: [
        // Город и время обновления
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                weather.cityName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Обновлено: ${_formatTime(weather.lastUpdated)}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        
        // Основная информация о погоде
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Температура и описание
            Column(
              children: [
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _capitalize(weather.description),
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            
            // Дополнительная информация
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWeatherDetail('💧 Влажность', '${weather.humidity}%'),
                const SizedBox(height: 8),
                _buildWeatherDetail('💨 Ветер', '${weather.windSpeed.toStringAsFixed(1)} м/с'),
              ],
            ),
          ],
        ),
        
        // Иконка погоды (если есть)
        if (weather.iconCode.isNotEmpty) ...[
          const SizedBox(height: 16),
          Image.network(
            weatherProvider.getWeatherIconUrl(weather.iconCode),
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.cloud, size: 50, color: Colors.blue);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}