import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода и привычки'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return ListView(
            children: [
              WeatherCard(showDetailsButton: false), // Убрали кнопку "Подробнее"
              _buildWeatherHistory(weatherProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeatherHistory(WeatherProvider weatherProvider) {
    if (weatherProvider.weatherHistory.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'История запросов погоды пуста',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📊 История запросов',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: weatherProvider.clearHistory,
                  tooltip: 'Очистить историю',
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...weatherProvider.weatherHistory.map((weather) => ListTile(
              leading: const Icon(Icons.cloud, color: Colors.blue),
              title: Text(weather.cityName),
              subtitle: Text('${weather.temperature.toStringAsFixed(1)}°C - ${weather.description}'),
              trailing: Text(
                _formatDateTime(weather.lastUpdated),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}