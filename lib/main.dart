import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_habit_screen.dart';
import 'screens/statistics_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      
      home: const HomeScreen(),
    );
  }
}