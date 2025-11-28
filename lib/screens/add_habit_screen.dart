import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedFrequency = 'daily';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (_formKey.currentState!.validate()) {
      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        frequency: _selectedFrequency,
        progress: 0.0,
        streak: 0,
        isCompletedToday: false,
      );

      Provider.of<HabitProvider>(context, listen: false).addHabit(newHabit);

      // Показываем сообщение об успехе
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Привычка успешно добавлена!'),
          backgroundColor: Colors.green,
        ),
      );

      // Возвращаемся на главный экран
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить привычку'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Поле для названия привычки
              const Text(
                'Название привычки *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Например: Утренняя зарядка',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название привычки';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Поле для описания
              const Text(
                'Описание',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Описание вашей привычки...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Выбор периодичности
              const Text(
                'Периодичность *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: _selectedFrequency,
                items: const [
                  DropdownMenuItem(
                    value: 'daily',
                    child: Text('Ежедневно'),
                  ),
                  DropdownMenuItem(
                    value: 'weekly',
                    child: Text('Еженедельно'),
                  ),
                  DropdownMenuItem(
                    value: 'monthly',
                    child: Text('Ежемесячно'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFrequency = value!;
                  });
                },
              ),
              
              const SizedBox(height: 30),
              
              // Кнопка сохранения
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Сохранить привычку',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}