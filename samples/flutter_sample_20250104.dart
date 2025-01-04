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
  final List<String> temperatures = ['22°C', '18°C', '25°C', '20°C', '28°C'];
  final List<IconData> weatherIcons = [
    Icons.cloud,
    Icons.water_drop,
    Icons.sunny,
    Icons.cloudy_snowing,
    Icons.wb_sunny
  ];

  int selectedCityIndex = 0;
  bool isCelsius = true;

  String convertTemperature(String temp) {
    if (isCelsius) return temp;
    int celsius = int.parse(temp.substring(0, temp.length - 2));
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
            value: isCelsius,
            onChanged: (value) {
              setState(() {
                isCelsius = value;
              });
            },
            activeThumbImage: const AssetImage('assets/celsius.png'),
            inactiveThumbImage: const AssetImage('assets/fahrenheit.png'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  weatherIcons[selectedCityIndex],
                  size: 64,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  cities[selectedCityIndex],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  convertTemperature(temperatures[selectedCityIndex]),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Icon(weatherIcons[index]),
                    title: Text(cities[index]),
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
                _buildWeatherDetail(Icons.water_drop, '75%', 'Humidity'),
                _buildWeatherDetail(Icons.air, '12 km/h', 'Wind'),
                _buildWeatherDetail(Icons.visibility, '10 km', 'Visibility'),
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

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(8),
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