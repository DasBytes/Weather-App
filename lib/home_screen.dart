import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_flutter/provider/theme_provider.dart';
import 'package:weather_flutter/service/api_service_dart';

class WeatherAppHomeScreen extends ConsumerStatefulWidget {
  const WeatherAppHomeScreen({super.key});

  @override
  ConsumerState<WeatherAppHomeScreen> createState() =>
      _WeatherAppHomeScreenState();
}

class _WeatherAppHomeScreenState
    extends ConsumerState<WeatherAppHomeScreen> {
      final _weatherService = WeatherApiService();
        String city ="Surkhet";
        String country = '';
        Map<String, dynamic> currentValue = {};
        List<dynamic> hourly =[];
        List<dynamic> pastWeek =[];
        List<dynamic> next7days =[];
        
        bool isLoading = false;

        @override
  void initState() {
    
    super.initState();
    _fetchWeather();
  }
  Future<void> _fetchWeather() async {
    setState(() {
      isLoading = true;
    });
    try {
      final forecast = await _weatherService.getHourlyForecast(city);
      final past = await _weatherService.getpast(city);

    } catch (e) {
      Em
      
    }
  }


  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeNotifierProvider); // ✅ Moved inside build
    final notifier = ref.read(themeNotifierProvider.notifier); // ✅ Moved inside build
    final isDark = themeMode == ThemeMode.dark; // ✅ Moved inside build

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          const SizedBox(width: 25),
          const SizedBox(
            width: 320,
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search city",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10), // Spacer removed (illegal in actions)
          GestureDetector(
            onTap: notifier.toggleTheme,
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode, // ✅ Fixed logic
              color: isDark ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(width: 25),
        ],
      ),
    );
  }
}
