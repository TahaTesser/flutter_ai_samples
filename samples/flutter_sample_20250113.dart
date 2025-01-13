import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
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
  final List<WeatherData> weeklyForecast = [
    WeatherData('Monday', 25, 'Sunny', 65),
    WeatherData('Tuesday', 23, 'Cloudy', 70),
    WeatherData('Wednesday', 22, 'Rainy', 85),
    WeatherData('Thursday', 24, 'Partly Cloudy', 60),
    WeatherData('Friday', 26, 'Sunny', 55),
    WeatherData('Saturday', 21, 'Stormy', 90),
    WeatherData('Sunday', 20, 'Rainy', 80),
  ];

  bool isMetric = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Dashboard'),
        actions: [
          Switch(
            value: isMetric,
            onChanged: (value) {
              setState(() {
                isMetric = value;
              });
            },
          ),
          const SizedBox(width: 8),
          Text(isMetric ? '°C' : '°F'),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          _buildCurrentWeather(),
          const Divider(),
          Expanded(
            child: _buildWeeklyForecast(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showWeatherAlert(context);
        },
        child: const Icon(Icons.warning_amber_rounded),
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Current Location',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, size: 20),
              const SizedBox(width: 4),
              const Text('New York, USA'),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    isMetric ? '25°C' : '77°F',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const Text('Sunny'),
                ],
              ),
              Column(
                children: const [
                  Icon(Icons.wb_sunny, size: 48),
                  SizedBox(height: 8),
                  Text('UV: High'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildWeatherDetails(),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDetailItem(Icons.water_drop, '65%', 'Humidity'),
        _buildDetailItem(Icons.air, '12 km/h', 'Wind'),
        _buildDetailItem(Icons.visibility, '10 km', 'Visibility'),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(value),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildWeeklyForecast() {
    return ListView.builder(
      itemCount: weeklyForecast.length,
      itemBuilder: (context, index) {
        final weather = weeklyForecast[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: _getWeatherIcon(weather.condition),
            title: Text(weather.day),
            subtitle: Text(weather.condition),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isMetric
                      ? '${weather.temperature}°C'
                      : '${(weather.temperature * 9 / 5 + 32).round()}°F',
                ),
                const SizedBox(width: 8),
                Text('${weather.humidity}%'),
              ],
            ),
          ),
        );
      },
    );
  }

  Icon _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return const Icon(Icons.wb_sunny);
      case 'cloudy':
        return const Icon(Icons.cloud);
      case 'rainy':
        return const Icon(Icons.water_drop);
      case 'stormy':
        return const Icon(Icons.thunderstorm);
      case 'partly cloudy':
        return const Icon(Icons.cloud_queue);
      default:
        return const Icon(Icons.question_mark);
    }
  }

  void _showWeatherAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Weather Alert'),
        content: const Text(
          'Severe thunderstorm warning in effect for your area. '
          'Please stay indoors and avoid travel if possible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Dismiss'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showDetailedAlert(context);
            },
            child: const Text('More Info'),
          ),
        ],
      ),
    );
  }

  void _showDetailedAlert(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Detailed Weather Alert',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'A severe thunderstorm is approaching from the southwest. '
              'Expected arrival time: 2 hours\n\n'
              'Potential hazards:\n'
              '• Heavy rainfall (50-75mm)\n'
              '• Strong winds (60-80 km/h)\n'
              '• Possible hail\n\n'
              'Please take necessary precautions and stay tuned for updates.',
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherData {
  final String day;
  final int temperature;
  final String condition;
  final int humidity;

  WeatherData(this.day, this.temperature, this.condition, this.humidity);
}