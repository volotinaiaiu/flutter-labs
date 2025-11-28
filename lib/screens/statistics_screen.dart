import '../models/habit.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  double _calculateTotalProgress(List<Habit> habits) {
    if (habits.isEmpty) return 0.0;
    final total = habits.map((h) => h.progress).reduce((a, b) => a + b);
    return total / habits.length;
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final totalProgress = _calculateTotalProgress(habitProvider.habits);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Общий прогресс',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Средний прогресс',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${(totalProgress * 100).round()}%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: totalProgress > 0.7 ? Colors.green : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: totalProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        totalProgress > 0.7 ? Colors.green : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Мотивационная цитата',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.blue[50],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 48,
                      color: Colors.amber,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Успех — это сумма небольших усилий, повторяющихся изо дня в день.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Роберт Колльер',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Активные привычки',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            habitProvider.habits.isEmpty
                ? const Center(
                    child: Text(
                      'Нет активных привычек',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : DataTable(
                    columns: const [
                      DataColumn(label: Text('Привычка')),
                      DataColumn(label: Text('Прогресс')),
                      DataColumn(label: Text('Дней')),
                    ],
                    rows: habitProvider.habits.map((habit) {
                      return DataRow(cells: [
                        DataCell(Text(habit.title)),
                        DataCell(Text('${(habit.progress * 100).round()}%')),
                        DataCell(Text('${habit.streak}')),
                      ]);
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}