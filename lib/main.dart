import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'providers/habit_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_habit_screen.dart';
import 'screens/statistics_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HabitProvider(),
      child: MaterialApp(
        title: 'HabitFlow',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/add': (context) => const AddHabitScreen(),
          '/stats': (context) => const StatisticsScreen(),
        },
      ),
    );
  }
}