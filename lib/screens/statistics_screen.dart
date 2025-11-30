import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final habits = habitProvider.habits;
    final stats = habitProvider.getStatistics();

    // Исправленный расчет общего прогресса
    final totalProgress = habits.isEmpty ? 0.0 : 
        habits.map((h) => h.progress).reduce((a, b) => a + b) / habits.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика привычек'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: habits.isEmpty
          ? _buildEmptyState()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Общая статистика
                _buildStatsCard(stats, totalProgress),
                const SizedBox(height: 20),
                // Таблица привычек
                _buildHabitsTable(habits),
                const SizedBox(height: 20),
                // Графики прогресса
                _buildProgressCharts(habits),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Нет данных для статистики',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Добавьте привычки для отслеживания прогресса',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(Map<String, dynamic> stats, double totalProgress) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Общая статистика',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Всего привычек',
                  '${stats['totalHabits']}',
                  Icons.list,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Выполнено сегодня',
                  '${stats['completedToday']}',
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatItem(
                  'Общий прогресс',
                  '${(totalProgress * 100).round()}%',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHabitsTable(List<dynamic> habits) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Детальная статистика по привычкам',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Привычка')),
                  DataColumn(label: Text('Категория')),
                  DataColumn(label: Text('Прогресс')),
                  DataColumn(label: Text('Серия')),
                  DataColumn(label: Text('Всего выполнений')),
                ],
                rows: habits.map((habit) {
                  return DataRow(
                    cells: [
                      DataCell(Text(habit.title)),
                      DataCell(Text(habit.category)),
                      DataCell(Text('${(habit.progress * 100).round()}%')),
                      DataCell(Text('${habit.streak}')),
                      DataCell(Text('${habit.completedDates.length}')),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCharts(List<dynamic> habits) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Прогресс по привычкам',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...habits.map((habit) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          habit.title,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text('${(habit.progress * 100).round()}%'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: habit.progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        habit.progress > 0.7 ? Colors.green : 
                        habit.progress > 0.4 ? Colors.blue : Colors.orange,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}