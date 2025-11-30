class Habit {
  final String id;
  final String title;
  final String category;
  final DateTime createdAt;
  final List<DateTime> completedDates;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
    required this.completedDates,
  });

  // Геттер для серии (количество дней подряд)
  int get streak {
    if (completedDates.isEmpty) return 0;
    
    final sortedDates = List<DateTime>.from(completedDates)..sort((a, b) => b.compareTo(a));
    int streak = 1;
    DateTime currentDate = sortedDates.first;
    
    for (int i = 1; i < sortedDates.length; i++) {
      final previousDate = sortedDates[i];
      final difference = currentDate.difference(previousDate).inDays;
      
      if (difference == 1) {
        streak++;
        currentDate = previousDate;
      } else {
        break;
      }
    }
    
    return streak;
  }

  // Геттер для прогресса (процент выполненных дней за последнюю неделю)
  double get progress {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final weekCompletions = completedDates.where((date) => date.isAfter(weekAgo)).length;
    return weekCompletions / 7;
  }

  // Геттер для описания (пустая строка, но метод существует)
  String get description => '';

  // Метод для создания копии с обновленными данными
  Habit copyWith({
    String? id,
    String? title,
    String? category,
    DateTime? createdAt,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  // Преобразование в Map для сохранения в базу данных
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  // Создание объекта Habit из Map
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
      completedDates: (map['completedDates'] as List)
          .map((date) => DateTime.parse(date))
          .toList(),
    );
  }

  // Проверка, выполнена ли привычка сегодня
  bool isCompletedToday() {
    final today = DateTime.now();
    return completedDates.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }

  // Добавление даты выполнения
  Habit markAsCompleted() {
    final newCompletedDates = List<DateTime>.from(completedDates);
    final now = DateTime.now();
    
    // Удаляем сегодняшнее выполнение если уже есть
    final todayCompletionIndex = newCompletedDates.indexWhere((date) =>
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day);
    
    if (todayCompletionIndex != -1) {
      newCompletedDates.removeAt(todayCompletionIndex);
    } else {
      newCompletedDates.add(now);
    }
    
    return copyWith(completedDates: newCompletedDates);
  }

  // Удаление сегодняшнего выполнения
  Habit markAsIncomplete() {
    final today = DateTime.now();
    final newCompletedDates = completedDates.where((date) =>
        !(date.year == today.year &&
          date.month == today.month &&
          date.day == today.day)).toList();
    
    return copyWith(completedDates: newCompletedDates);
  }
}