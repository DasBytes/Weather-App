import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_flutter/provider/theme_provider.dart';
import 'package:weather_flutter/service/api_service_dart';

import 'package:weather_flutter/weekly_forecast.dart';

class WeatherAppHomeScreen extends ConsumerStatefulWidget {
  const WeatherAppHomeScreen({super.key});

  @override
  ConsumerState<WeatherAppHomeScreen> createState() =>
      _WeatherAppHomeScreenState();
}

class _WeatherAppHomeScreenState extends ConsumerState<WeatherAppHomeScreen> {
  final _weatherService = WeatherApiService();
  String city = "Chittagong";
  String country = '';
  Map<String, dynamic> currentValue = {};
  List<dynamic> hourly = [];
  List<dynamic> pastWeek = [];
  List<dynamic> next7days = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() => isLoading = true);
    try {
      final forecast = await _weatherService.getHourlyForecast(city);
      final past = await _weatherService.getOastSevenDaysweather(city);

      setState(() {
        currentValue = forecast['current'] ?? {};
        hourly = forecast['forecast']?['forecastday']?[0]?['hour'] ?? [];
        next7days = forecast['forecast']?['forecastday'] ?? [];
        pastWeek = past;
        city = forecast['location']?['name'] ?? city;
        country = forecast['location']?['country'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        currentValue = {};
        hourly = [];
        pastWeek = [];
        next7days = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "City not found or invalid. Please enter a valid city name"),
        ),
      );
    }
  }

  String formatTime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat.j().format(time);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider);
    final notifier = ref.read(themeNotifierProvider.notifier);
    final isDark = themeMode == ThemeMode.dark;

    String iconPath = currentValue['condition']?['icon'] ?? '';
    String imageUrl = iconPath.isNotEmpty ? "https:$iconPath" : "";

    Widget imageWidget = imageUrl.isNotEmpty
        ? Image.network(imageUrl, height: 180, width: 180, fit: BoxFit.cover)
        : const SizedBox();

    return Scaffold(
      // === ADD DRAWER HERE ===
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.grey.shade900, Colors.grey.shade800]
                      : [Colors.blue.shade200, Colors.blue.shade400],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Favorite Cities'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavoriteCitiesPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About / Help'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutHelpPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey.shade900, Colors.grey.shade800]
                : [Colors.blue.shade200, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Search and theme toggle
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade700 : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            onSubmitted: (value) {
                              if (value.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please enter a city name")),
                                );
                                return;
                              }
                              setState(() {
                                city = value.trim();
                              });
                              _fetchWeather();
                            },
                            decoration: InputDecoration(
                              hintText: "Search city",
                              hintStyle: TextStyle(
                                color: isDark ? Colors.white70 : Colors.grey,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: isDark ? Colors.white : Colors.black87,
                                size: 24,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(15),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Material(
                        color: isDark ? Colors.white : Colors.black,
                        shape: const CircleBorder(),
                        child: IconButton(
                          iconSize: 24,
                          icon: Icon(
                            isDark ? Icons.light_mode : Icons.dark_mode,
                            color: isDark ? Colors.black : Colors.white,
                          ),
                          onPressed: notifier.toggleTheme,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (currentValue.isNotEmpty)
                  Column(
                    children: [
                      // City
                      Text(
                        "$city${country.isNotEmpty ? ', $country' : ''}",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Temperature
                      Text(
                        "${currentValue['temp_c']}°C",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Condition
                      Text(
                        "${currentValue['condition']?['text'] ?? ''}",
                        style: TextStyle(
                          fontSize: 22,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      imageWidget,
                      const SizedBox(height: 15),

                      // Weather stats card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade800 : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatColumn(
                                  "Humidity",
                                  "${currentValue['humidity'] ?? 'N/A'}%",
                                  "https://cdn-icons-png.freepik.com/512/9290/9290540.png",
                                  isDark),
                              _buildStatColumn(
                                  "Wind",
                                  "${currentValue['wind_kph'] ?? 'N/A'} kph",
                                  "https://png.pngtree.com/png-clipart/20190705/original/pngtree-vector-wind-icon-png-image_4184509.jpg",
                                  isDark),
                              _buildStatColumn(
                                  "Max Temp",
                                  (hourly.isNotEmpty && hourly.first['temp_c'] != null)
                                      ? "${hourly.map((h) => h['temp_c']).reduce((a, b) => a > b ? a : b)}°C"
                                      : "N/A",
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbJS4wbuG9-dwHi7BFEESu4TLLIWIUBRmacw&s",
                                  isDark),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      _buildHourlyForecast(isDark),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _buildStatColumn(
      String label, String value, String iconUrl, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          iconUrl,
          width: 30,
          height: 30,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildHourlyForecast(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.blue.shade100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Text(
                  "Today Forecast",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeeklyForecast(
                          city: city,
                          currentValue: currentValue,
                          pastWeek: pastWeek,
                          next7days: next7days,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Weekly Forecast",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.orangeAccent : Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.white24),
          const SizedBox(height: 10),
          SizedBox(
            height: 165,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourly.length,
              itemBuilder: (context, index) {
                final hour = hourly[index];
                final now = DateTime.now();
                final hourTime = DateTime.parse(hour['time']);
                final isCurrentHour =
                    now.hour == hourTime.hour && now.day == hourTime.day;

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isCurrentHour
                          ? Colors.orangeAccent
                          : isDark
                              ? Colors.grey.shade800
                              : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isCurrentHour ? "Now" : formatTime(hour['time']),
                          style: TextStyle(
                            color: isCurrentHour
                                ? Colors.white
                                : isDark
                                    ? Colors.white70
                                    : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.network(
                          "https:${hour['condition']?['icon']}",
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${hour["temp_c"]}°C",
                          style: TextStyle(
                            color: isCurrentHour
                                ? Colors.white
                                : isDark
                                    ? Colors.white70
                                    : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

// === CREATE SEPARATE PAGES ===
class FavoriteCitiesPage extends StatelessWidget {
  const FavoriteCitiesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Cities")),
      body: const Center(child: Text("List of saved favorite cities")),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: const Center(child: Text("App settings (units, notifications, theme)")),
    );
  }
}

class AboutHelpPage extends StatelessWidget {
  const AboutHelpPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About / Help")),
      body: const Center(child: Text("App info, developer contact, FAQs")),
    );
  }
}
