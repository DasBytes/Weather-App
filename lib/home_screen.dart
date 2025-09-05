import 'dart:ui';
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
  String city = "Surkhet";
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
      final past = await _weatherService.getPastSevenDaysWeather(city);

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
          content: Text("Failed to fetch weather. Check city or API key."),
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
        ? Image.network(
            imageUrl,
            height: 180,
            width: 180,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.cloud_off, size: 80),
          )
        : const SizedBox();
String sunrise = "N/A";
String sunset = "N/A";

if (next7days.isNotEmpty) {
  final firstDay = next7days.first;
  if (firstDay is Map<String, dynamic>) {
    final astro = firstDay['astro'];
    if (astro is Map<String, dynamic>) {
      sunrise = astro['sunrise']?.toString() ?? "N/A";
      sunset = astro['sunset']?.toString() ?? "N/A";
    }
  }
}


    return Scaffold(
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
                // Search + Theme toggle
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
                          icon: Icon(
                            isDark ? Icons.dark_mode : Icons.dark_mode,
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
                      Text(
                        "$city${country.isNotEmpty ? ', $country' : ''}",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.grey.shade900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${currentValue['temp_c']}°C",
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${currentValue['condition']?['text'] ?? ''}",
                        style: TextStyle(
                          fontSize: 20,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      imageWidget,
                      const SizedBox(height: 15),

                      // Single modern stats container for Humidity, Wind & Max Temp
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: isDark
                                ? LinearGradient(
                                    colors: [
                                      Colors.grey.shade800.withOpacity(0.7),
                                      Colors.grey.shade700.withOpacity(0.5)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.9),
                                      Colors.blue.shade100.withOpacity(0.3)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildCombinedStat(
                                  "Humidity",
                                  "${currentValue['humidity'] ?? 'N/A'}%",
                                  Icons.opacity,
                                  Colors.blueAccent,
                                  isDark),
                              _buildCombinedStat(
                                  "Wind",
                                  "${currentValue['wind_kph'] ?? 'N/A'} kph",
                                  Icons.air,
                                  Colors.greenAccent,
                                  isDark),
                              _buildCombinedStat(
                                  "Max Temp",
                                  (hourly.isNotEmpty && hourly.first['temp_c'] != null)
                                      ? "${hourly.map((h) => h['temp_c']).reduce((a, b) => a > b ? a : b)}°C"
                                      : "N/A",
                                  Icons.thermostat,
                                  Colors.redAccent,
                                  isDark),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      _buildHourlyForecast(isDark),

                      // Sunrise & Sunset container
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            gradient: isDark
                                ? LinearGradient(
                                    colors: [
                                      Colors.orange.shade800.withOpacity(0.7),
                                      Colors.orange.shade600.withOpacity(0.5)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [
                                      Colors.orange.shade200.withOpacity(0.9),
                                      Colors.orange.shade100.withOpacity(0.4)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: const Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildCombinedStat("Sunrise", sunrise, Icons.wb_sunny,
                                  Colors.yellowAccent, isDark),
                              _buildCombinedStat("Sunset", sunset, Icons.nightlight_round,
                                  Colors.deepOrangeAccent, isDark),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedStat(
      String label, String value, IconData icon, Color color, bool isDark) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color.withOpacity(0.4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87),
        ),
        Text(
          label,
          style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHourlyForecast(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  "Hourly Forecast",
                  style: TextStyle(
                    fontSize: 22,
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
                  child: Row(
                    children: [
                      Text(
                        "7-Day",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.orangeAccent : Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: isDark ? Colors.orangeAccent : Colors.blueAccent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Horizontal scroll luxury cards
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourly.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final hour = hourly[index];
                final now = DateTime.now();
                final hourTime = DateTime.parse(hour['time']);
                final isCurrentHour =
                    now.hour == hourTime.hour && now.day == hourTime.day;

                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        width: 140,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: isCurrentHour
                              ? LinearGradient(
                                  colors: [
                                    Colors.orangeAccent,
                                    Colors.deepOrange
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : LinearGradient(
                                  colors: isDark
                                      ? [
                                          Colors.grey.shade800.withOpacity(0.6),
                                          Colors.grey.shade700.withOpacity(0.4)
                                        ]
                                      : [
                                          Colors.white.withOpacity(0.6),
                                          Colors.blue.shade100.withOpacity(0.4)
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: isCurrentHour
                                  ? Colors.orangeAccent.withOpacity(0.4)
                                  : Colors.black26,
                              blurRadius: 10,
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                isCurrentHour ? "Now" : formatTime(hour['time']),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentHour
                                      ? Colors.white
                                      : isDark
                                          ? Colors.white70
                                          : Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCurrentHour
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.transparent,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Image.network(
                                "https:${hour['condition']?['icon']}",
                                width: 50,
                                height: 50,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.cloud_off, size: 45),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "${hour['temp_c']}°C",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentHour
                                      ? Colors.white
                                      : isDark
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                            ),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  hour['condition']?['text'] ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isCurrentHour
                                        ? Colors.white70
                                        : isDark
                                            ? Colors.white54
                                            : Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
