import 'package:flutter/material.dart';

class AddHabitScreen extends StatelessWidget {
  const AddHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить привычку'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поле для названия привычки
            const Text(
              'Название привычки',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Например: Утренняя зарядка',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
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
            TextField(
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
              'Цель',
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
              value: 'daily',
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
              onChanged: null, // Пока без логики
            ),
            
            const SizedBox(height: 30),
            
            // Кнопка сохранения
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: null, // Пока без логики
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
    );
  }
}