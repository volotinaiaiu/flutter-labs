import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/habit_provider.dart';
import 'providers/weather_provider.dart';
import 'services/weather_api_service.dart';
import 'services/local_storage_service.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Провайдер для привычек
        ChangeNotifierProvider<HabitProvider>(
          create: (context) => HabitProvider(),
        ),
        
        // Провайдеры для погоды
        Provider<WeatherApiService>(
          create: (_) => WeatherApiService(),
        ),
        Provider<LocalStorageService>(
          create: (_) => LocalStorageService(),
        ),
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(
            apiService: context.read<WeatherApiService>(),
            localStorageService: context.read<LocalStorageService>(),
          )..loadLastCity(),
        ),
      ],
      child: MaterialApp(
        title: 'Трекер привычек с погодой',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            // Явно укажем, что не хотим автоматических кнопок
            actionsIconTheme: IconThemeData(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}