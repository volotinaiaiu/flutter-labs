import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import 'add_habit_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitFlow'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: habitProvider.habits.isEmpty
          ? const Center(
              child: Text(
                'Добавьте свою первую привычку!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView(
              children: habitProvider.habits.map((habit) {
                return HabitCard(
                  habit: habit,
                  onComplete: () {
                    habitProvider.toggleHabitCompletion(habit.id);
                  },
                  onEdit: () {
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Редактирование будет в следующей лабораторной'),
                      ),
                    );
                  },
                  onDelete: () {
                    habitProvider.removeHabit(habit.id);
                  },
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHabitScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}