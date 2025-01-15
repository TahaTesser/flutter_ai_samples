import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1A1A2F),
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
  final List<String> temperatures = ['24°C', '18°C', '27°C', '21°C', '23°C'];
  final List<IconData> weatherIcons = [
    Icons.wb_sunny,
    Icons.cloud,
    Icons.water_drop,
    Icons.cloudy_snowing,
    Icons.thunderstorm
  ];

  int selectedCityIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildMainWeatherCard(),
            _buildWeatherDetails(),
            _buildHourlyForecast(),
            _buildWeeklyForecast(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cities[selectedCityIndex],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Monday, 12 March',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMainWeatherCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(
            weatherIcons[selectedCityIndex],
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            temperatures[selectedCityIndex],
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'Partly Cloudy',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildDetailItem(Icons.water_drop, '75%', 'Humidity'),
          _buildDetailItem(Icons.air, '12 km/h', 'Wind'),
          _buildDetailItem(Icons.visibility, '10 km', 'Visibility'),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecast() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (context, index) {
          return Container(
            width: 60,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('${index + 1}h'),
                const Icon(Icons.wb_sunny, size: 20),
                Text('${20 + index % 5}°'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeeklyForecast() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDayName(index),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(weatherIcons[index % 5], size: 20),
                    const SizedBox(width: 8),
                    Text('${20 + index}° / ${15 + index}°'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getDayName(int index) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[index];
  }
}