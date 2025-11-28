import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final double progress;
  final int streak;

  const HabitCard({
    super.key,
    required this.title,
    required this.progress,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и количество дней
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text('$streak дн.'),
                  backgroundColor: Colors.green[100],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Прогресс-бар
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.7 ? Colors.green : Colors.blue,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Процент выполнения и кнопки
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress * 100).round()}% выполнено',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    // Кнопка выполнения
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: null, // Пока без логики
                      color: Colors.green,
                    ),
                    // Кнопка редактирования
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: null, // Пока без логики
                      color: Colors.blue,
                    ),
                    // Кнопка удаления
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: null, // Пока без логики
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}