import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onComplete;
  final VoidCallback onDelete;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.onComplete,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.isCompletedToday();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и кнопки
            Row(
              children: [
                // Иконка категории
                Icon(
                  _getCategoryIcon(habit.category),
                  color: _getCategoryColor(habit.category),
                  size: 24,
                ),
                const SizedBox(width: 12),
                // Название привычки
                Expanded(
                  child: Text(
                    habit.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      color: isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                // Кнопки действий
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isCompleted ? Colors.green : Colors.grey,
                      ),
                      onPressed: onComplete,
                      tooltip: isCompleted ? 'Отметить как невыполненную' : 'Отметить как выполненную',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                      tooltip: 'Удалить привычку',
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Категория и статистика
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(habit.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    habit.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getCategoryColor(habit.category),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Серия
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: habit.streak >= 7 ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 12,
                        color: habit.streak >= 7 ? Colors.green : Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.streak} дн.',
                        style: TextStyle(
                          fontSize: 12,
                          color: habit.streak >= 7 ? Colors.green : Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Прогресс за неделю
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Прогресс за неделю:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${(habit.progress * 100).round()}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: habit.progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    habit.progress > 0.7 ? Colors.green : Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Общая статистика
            Text(
              'Выполнено: ${habit.completedDates.length} раз',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}