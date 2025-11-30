import 'package:flutter/foundation.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  // Добавление новой привычки
  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  }

  // Удаление привычки
  void deleteHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
    notifyListeners();
  }

  // Переключение статуса выполнения привычки
  void toggleHabitCompletion(String id) {
    final index = _habits.indexWhere((habit) => habit.id == id);
    if (index != -1) {
      final habit = _habits[index];
      final updatedHabit = habit.isCompletedToday() 
          ? habit.markAsIncomplete()
          : habit.markAsCompleted();
      
      _habits[index] = updatedHabit;
      notifyListeners();
    }
  }

  // Получение привычки по ID
  Habit? getHabitById(String id) {
    try {
      return _habits.firstWhere((habit) => habit.id == id);
    } catch (e) {
      return null;
    }
  }

  // Обновление привычки
  void updateHabit(String id, String newTitle, String newCategory) {
    final index = _habits.indexWhere((habit) => habit.id == id);
    if (index != -1) {
      final habit = _habits[index];
      final updatedHabit = habit.copyWith(
        title: newTitle,
        category: newCategory,
      );
      _habits[index] = updatedHabit;
      notifyListeners();
    }
  }

  // Получение статистики
  Map<String, dynamic> getStatistics() {
    final totalHabits = _habits.length;
    final completedToday = _habits.where((habit) => habit.isCompletedToday()).length;
    final totalCompletions = _habits.fold(0, (sum, habit) => sum + habit.completedDates.length);
    
    return {
      'totalHabits': totalHabits,
      'completedToday': completedToday,
      'totalCompletions': totalCompletions,
    };
  }

  // Для веб-версии временно не используем базу данных
  Future<void> loadHabits() async {
    // В веб-версии пока храним в памяти
    await Future.delayed(const Duration(milliseconds: 100));
    notifyListeners();
  }

  Future<void> saveHabits() async {
    // В веб-версии пока храним в памяти
    await Future.delayed(const Duration(milliseconds: 100));
  }
}