import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const WeatherDashboard(),
    );
  }
}

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({super.key});

  @override
  State<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  final List<String> cities = ['New York', 'London', 'Tokyo', 'Paris', 'Sydney'];
  String selectedCity = 'New York';
  bool isLoading = false;
  bool isFavorite = false;

  final Map<String, Map<String, dynamic>> weatherData = {
    'New York': {
      'temperature': 22,
      'condition': 'Sunny',
      'humidity': 65,
      'windSpeed': 12,
    },
    'London': {
      'temperature': 18,
      'condition': 'Cloudy',
      'humidity': 75,
      'windSpeed': 15,
    },
    'Tokyo': {
      'temperature': 28,
      'condition': 'Rainy',
      'humidity': 80,
      'windSpeed': 8,
    },
    'Paris': {
      'temperature': 24,
      'condition': 'Partly Cloudy',
      'humidity': 70,
      'windSpeed': 10,
    },
    'Sydney': {
      'temperature': 26,
      'condition': 'Clear',
      'humidity': 60,
      'windSpeed': 14,
    },
  };

  void _refreshWeather() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentWeather = weatherData[selectedCity]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshWeather();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        DropdownButton<String>(
                          value: selectedCity,
                          isExpanded: true,
                          items: cities.map((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCity = newValue!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        if (isLoading)
                          const CircularProgressIndicator()
                        else
                          Column(
                            children: [
                              Icon(
                                _getWeatherIcon(currentWeather['condition']),
                                size: 64,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${currentWeather['temperature']}°C',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currentWeather['condition'],
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        'Humidity',
                        '${currentWeather['humidity']}%',
                        Icons.water_drop,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoCard(
                        'Wind Speed',
                        '${currentWeather['windSpeed']} km/h',
                        Icons.air,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hourly Forecast',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 24,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Text('${index}:00'),
                                    const Icon(Icons.wb_sunny),
                                    Text('${currentWeather['temperature'] + (index % 5 - 2)}°C'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshWeather,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.beach_access;
      case 'partly cloudy':
        return Icons.cloud_queue;
      case 'clear':
        return Icons.wb_sunny_outlined;
      default:
        return Icons.wb_sunny;
    }
  }
}