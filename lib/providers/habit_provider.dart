import 'package:flutter/material.dart';
import '../models/habit.dart';

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = [
    Habit(
      id: '1',
      title: 'Утренняя зарядка',
      description: 'Ежедневная утренняя зарядка 15 минут',
      frequency: 'daily',
      progress: 0.7,
      streak: 5,
      isCompletedToday: false,
    ),
    Habit(
      id: '2',
      title: 'Чтение книги',
      description: 'Чтение 30 минут перед сном',
      frequency: 'daily',
      progress: 0.4,
      streak: 3,
      isCompletedToday: false,
    ),
    Habit(
      id: '3',
      title: 'Прогулка на свежем воздухе',
      description: 'Прогулка в парке 40 минут',
      frequency: 'daily',
      progress: 0.9,
      streak: 7,
      isCompletedToday: false,
    ),
  ];

  List<Habit> get habits => _habits;

  // Добавление новой привычки
  void addHabit(Habit newHabit) {
    _habits.add(newHabit);
    notifyListeners();
  }

  // Удаление привычки
  void removeHabit(String habitId) {
    _habits.removeWhere((habit) => habit.id == habitId);
    notifyListeners();
  }

  // Отметка привычки как выполненной сегодня
  void toggleHabitCompletion(String habitId) {
    final index = _habits.indexWhere((habit) => habit.id == habitId);
    if (index != -1) {
      final habit = _habits[index];
      final newProgress = habit.isCompletedToday 
          ? habit.progress - 0.1 
          : habit.progress + 0.1;
      
      _habits[index] = habit.copyWith(
        isCompletedToday: !habit.isCompletedToday,
        progress: newProgress.clamp(0.0, 1.0),
        streak: habit.isCompletedToday 
            ? habit.streak - 1 
            : habit.streak + 1,
      );
      notifyListeners();
    }
  }

  // Обновление прогресса привычки
  void updateHabitProgress(String habitId, double newProgress) {
    final index = _habits.indexWhere((habit) => habit.id == habitId);
    if (index != -1) {
      _habits[index] = _habits[index].copyWith(progress: newProgress);
      notifyListeners();
    }
  }
}