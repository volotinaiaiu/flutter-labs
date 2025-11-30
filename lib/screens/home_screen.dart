import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/weather_card.dart';
import '../providers/habit_provider.dart';
import 'add_habit_screen.dart';
import 'statistics_screen.dart';
import 'weather_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Трекер привычек'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatisticsScreen()),
              );
            },
            tooltip: 'Статистика',
          ),
          IconButton(
            icon: const Icon(Icons.cloud),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()),
              );
            },
            tooltip: 'Погода',
          ),
        ],
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          final habits = habitProvider.habits;
          
          return Column(
            children: [
              // Виджет погоды
              WeatherCard(),
              
              // Заголовок и статистика привычек
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Мои привычки',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, size: 16, color: Colors.blue),
                          const SizedBox(width: 4),
                          Text(
                            '${habits.where((h) => h.isCompletedToday()).length}/${habits.length}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Список привычек
              Expanded(
                child: habits.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: habits.length,
                        itemBuilder: (context, index) {
                          final habit = habits[index];
                          return HabitCard(
                            habit: habit,
                            onComplete: () {
                              _toggleHabitCompletion(context, habitProvider, habit.id);
                            },
                            onDelete: () {
                              _showDeleteDialog(context, habitProvider, habit.id, habit.title);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddHabitScreen(context);
        },
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.psychology_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Пока нет привычек',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Добавьте первую привычку!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleHabitCompletion(BuildContext context, HabitProvider habitProvider, String habitId) {
    habitProvider.toggleHabitCompletion(habitId);
    
    final habit = habitProvider.getHabitById(habitId);
    if (habit != null) {
      final message = habit.isCompletedToday() 
          ? 'Привычка "${habit.title}" выполнена!' 
          : 'Привычка "${habit.title}" не выполнена';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: habit.isCompletedToday() ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showDeleteDialog(BuildContext context, HabitProvider habitProvider, String habitId, String habitTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить привычку?'),
          content: Text('Вы уверены, что хотите удалить привычку "$habitTitle"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                habitProvider.deleteHabit(habitId);
                Navigator.of(context).pop();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Привычка удалена'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddHabitScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitScreen()),
    );
  }
}