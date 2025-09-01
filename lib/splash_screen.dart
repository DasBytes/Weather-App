import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_flutter/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Navigate to HomeScreen after 3 seconds
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WeatherAppHomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.grey.shade900;
    final buttonColor = isDark ? Colors.orangeAccent : Colors.blueAccent;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  "Discover The\nWeather In Your City",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.2,
                    color: textColor,
                  ),
                ),
                const Spacer(),
                // Splash Image
                Image.asset(
                  "assets/cloudy.png",
                  height: 300,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
                Text(
                  "Get to know your weather maps, radar, precipitation forecasts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColor.withOpacity(0.85),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    elevation: 5,
                  ),
                  onPressed: () {
                    _timer.cancel();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WeatherAppHomeScreen()),
                    );
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
