import 'package:flutter/material.dart';
import '../widgets/habit_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Верхняя панель приложения
      appBar: AppBar(
        title: const Text('HabitFlow'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Кнопка перехода к статистике
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: null, // Пока без логики
          ),
        ],
      ),
      
      // Основное содержимое экрана
      body: ListView(
        children: const [
          // Карточка привычки 1
          HabitCard(
            title: 'Утренняя зарядка',
            progress: 0.7,    // 70% выполнено
            streak: 5,        // 5 дней подряд
          ),
          
          // Карточка привычки 2
          HabitCard(
            title: 'Чтение книги',
            progress: 0.4,    // 40% выполнено
            streak: 3,        // 3 дня подряд
          ),
          
          // Карточка привычки 3
          HabitCard(
            title: 'Прогулка на свежем воздухе',
            progress: 0.9,    // 90% выполнено
            streak: 7,        // 7 дней подряд
          ),
        ],
      ),
      
      // Плавающая кнопка добавления
      floatingActionButton: FloatingActionButton(
        onPressed: null, // Пока без логики
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}