class Habit {
  final String id;
  final String title;
  final String description;
  final String frequency;
  final double progress;
  final int streak;
  final bool isCompletedToday;

  Habit({
    required this.id,
    required this.title,
    required this.description,
    required this.frequency,
    required this.progress,
    required this.streak,
    required this.isCompletedToday,
  });

  // Метод для создания копии с обновленными значениями
  Habit copyWith({
    String? id,
    String? title,
    String? description,
    String? frequency,
    double? progress,
    int? streak,
    bool? isCompletedToday,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      progress: progress ?? this.progress,
      streak: streak ?? this.streak,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
    );
  }
}