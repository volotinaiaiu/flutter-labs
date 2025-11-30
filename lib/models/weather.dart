class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final DateTime lastUpdated;
  final String iconCode;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.lastUpdated,
    required this.iconCode,
  });

  // Для преобразования в Map для хранения
  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'description': description,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'lastUpdated': lastUpdated.toIso8601String(),
      'iconCode': iconCode,
    };
  }

  // Для создания объекта из Map
  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      cityName: map['cityName'],
      temperature: map['temperature'].toDouble(),
      description: map['description'],
      humidity: map['humidity'],
      windSpeed: map['windSpeed'].toDouble(),
      lastUpdated: DateTime.parse(map['lastUpdated']),
      iconCode: map['iconCode'],
    );
  }

  // Для копирования объекта с изменениями
  Weather copyWith({
    String? cityName,
    double? temperature,
    String? description,
    int? humidity,
    double? windSpeed,
    DateTime? lastUpdated,
    String? iconCode,
  }) {
    return Weather(
      cityName: cityName ?? this.cityName,
      temperature: temperature ?? this.temperature,
      description: description ?? this.description,
      humidity: humidity ?? this.humidity,
      windSpeed: windSpeed ?? this.windSpeed,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      iconCode: iconCode ?? this.iconCode,
    );
  }

  @override
  String toString() {
    return 'Weather(cityName: $cityName, temperature: $temperature, description: $description, humidity: $humidity, windSpeed: $windSpeed)';
  }
}