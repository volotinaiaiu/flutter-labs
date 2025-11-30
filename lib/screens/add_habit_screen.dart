import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../providers/weather_provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _selectedCategory = 'Здоровье';
  bool _addWeatherContext = false;

  final List<String> _categories = [
    'Здоровье',
    'Спорт',
    'Образование',
    'Работа',
    'Личное',
    'Другое'
  ];

  @override
  void initState() {
    super.initState();
    // Загружаем последний город при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);
      weatherProvider.loadLastCity();
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final weatherProvider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить привычку'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveHabit,
            tooltip: 'Сохранить привычку',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Поле названия привычки
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название привычки *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.text_fields),
                  hintText: 'Например: Утренняя зарядка',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название привычки';
                  }
                  if (value.length < 2) {
                    return 'Название должно содержать минимум 2 символа';
                  }
                  return null;
                },
                maxLength: 50,
              ),
              const SizedBox(height: 20),

              // Выбор категории
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Категория *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Row(
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          color: _getCategoryColor(category),
                        ),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, выберите категорию';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Секция контекста погоды
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.cloud, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Контекст погоды',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Добавить текущую погоду к привычке для отслеживания влияния погодных условий на выполнение привычек.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Добавить погоду к привычке'),
                        subtitle: const Text('Это поможет анализировать влияние погоды на ваши привычки'),
                        value: _addWeatherContext,
                        onChanged: (bool value) {
                          setState(() {
                            _addWeatherContext = value;
                          });
                        },
                      ),
                      
                      // Отображение текущей погоды если опция активна
                      if (_addWeatherContext) ...[
                        const SizedBox(height: 12),
                        _buildWeatherInfo(weatherProvider),
                      ],
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Кнопка сохранения
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Добавить привычку',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Виджет информации о погоде
  Widget _buildWeatherInfo(WeatherProvider weatherProvider) {
    if (weatherProvider.currentWeather == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Погода не установлена',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            const SizedBox(height: 4),
            const Text(
              'Сначала установите погоду на главном экране',
              style: TextStyle(fontSize: 12, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Закрываем текущий экран
                // Пользователь перейдет на главный экран и установит погоду
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 36),
              ),
              child: const Text('Установить погоду'),
            ),
          ],
        ),
      );
    }

    final weather = weatherProvider.currentWeather!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud, color: Colors.blue, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Погода: ${weather.cityName}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${weather.temperature.toStringAsFixed(1)}°C, ${weather.description}'),
                Text(
                  'Влажность: ${weather.humidity}%, Ветер: ${weather.windSpeed.toStringAsFixed(1)} м/с',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Сохранение привычки
  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final habitProvider = Provider.of<HabitProvider>(context, listen: false);
      final weatherProvider = Provider.of<WeatherProvider>(context, listen: false);

      // Создаем новую привычку
      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        category: _selectedCategory,
        createdAt: DateTime.now(),
        completedDates: [],
      );

      // Добавляем привычку
      habitProvider.addHabit(newHabit);

      // Сохраняем связь с погодой если нужно
      if (_addWeatherContext && weatherProvider.currentWeather != null) {
        weatherProvider.saveWeatherForHabit(newHabit.id);
      }

      // Показываем уведомление
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Привычка "${_titleController.text}" добавлена!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Возвращаемся на главный экран
      Navigator.pop(context);
    }
  }

  // Получение иконки для категории
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'здоровье':
        return Icons.favorite;
      case 'спорт':
        return Icons.sports;
      case 'образование':
        return Icons.school;
      case 'работа':
        return Icons.work;
      case 'личное':
        return Icons.person;
      default:
        return Icons.star;
    }
  }

  // Получение цвета для категории
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'здоровье':
        return Colors.red;
      case 'спорт':
        return Colors.blue;
      case 'образование':
        return Colors.green;
      case 'работа':
        return Colors.orange;
      case 'личное':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}