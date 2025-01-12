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
        scaffoldBackgroundColor: const Color(0xFF1D1E33),
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
  final List<String> conditions = ['Sunny', 'Rainy', 'Cloudy', 'Windy', 'Clear'];
  final List<IconData> weatherIcons = [
    Icons.wb_sunny,
    Icons.water_drop,
    Icons.cloud,
    Icons.air,
    Icons.nightlight_round
  ];

  int selectedCityIndex = 0;
  bool isMetric = true;

  String convertTemperature(String temp) {
    if (isMetric) return temp;
    int celsius = int.parse(temp.replaceAll('°C', ''));
    int fahrenheit = (celsius * 9 / 5 + 32).round();
    return '$fahrenheit°F';
  }

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
          const SizedBox(width: 10),
          Text(isMetric ? 'Celsius' : 'Fahrenheit'),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cities[selectedCityIndex],
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Icon(
                  weatherIcons[selectedCityIndex],
                  size: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  convertTemperature(temperatures[selectedCityIndex]),
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                ),
                Text(
                  conditions[selectedCityIndex],
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Icon(weatherIcons[index], color: Colors.blue),
                    title: Text(cities[index]),
                    subtitle: Text(conditions[index]),
                    trailing: Text(
                      convertTemperature(temperatures[index]),
                      style: const TextStyle(fontSize: 18),
                    ),
                    selected: selectedCityIndex == index,
                    onTap: () {
                      setState(() {
                        selectedCityIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfoCard('Humidity', '65%', Icons.water_outlined),
                _buildWeatherInfoCard('Wind', '12 km/h', Icons.air),
                _buildWeatherInfoCard('Pressure', '1015 hPa', Icons.speed),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildForecastSheet(),
          );
        },
        child: const Icon(Icons.calendar_today),
      ),
    );
  }

  Widget _buildWeatherInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildForecastSheet() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '5-Day Forecast',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Day ${index + 1}'),
                      const SizedBox(height: 8),
                      Icon(weatherIcons[index]),
                      const SizedBox(height: 8),
                      Text(convertTemperature(temperatures[index])),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}