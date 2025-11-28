import 'package:flutter/material.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок раздела
            const Text(
              'Общий прогресс',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Карточка общего прогресса
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Выполнено за месяц',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '65%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.65,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Мотивационная цитата
            const Text(
              'Мотивационная цитата',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.blue[50],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 48,
                      color: Colors.amber,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Успех — это сумма небольших усилий, повторяющихся изо дня в день.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Роберт Колльер',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Таблица активных привычек
            const Text(
              'Активные привычки',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DataTable(
              columns: const [
                DataColumn(label: Text('Привычка')),
                DataColumn(label: Text('Прогресс')),
                DataColumn(label: Text('Дней')),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('Зарядка')),
                  DataCell(Text('70%')),
                  DataCell(Text('5')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Чтение')),
                  DataCell(Text('40%')),
                  DataCell(Text('3')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Прогулка')),
                  DataCell(Text('90%')),
                  DataCell(Text('7')),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}