import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_flutter/provider/theme_provider.dart';

class WeatherAppHomeScreen extends ConsumerStatefulWidget {
  const WeatherAppHomeScreen({super.key});

  @override
  ConsumerState<WeatherAppHomeScreen> createState() => _WeatherAppHomeScreenState();
}

class _WeatherAppHomeScreenState extends ConsumerState<WeatherAppHomeScreen> {
final themeMode = ref.watch(themeNotifierProvider);
final notifier = ref.read(themeNotifierProvider.notifier);
final isDark = ThemeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Theme.of(context).primaryColor,
     appBar: AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        SizedBox(width: 25,),
        SizedBox(width: 320, height: 50, child: TextField(
          decoration: InputDecoration(
            labelText: "Search city",
            prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.surface),
            labelStyle: TextStyle(color: Theme.of(context).colorScheme.surface),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surface,
                 
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surface,
                 
              ),
            ),


          ),
        ),),
        Spacer(),
        GestureDetector(
          onTap: notifier.toggleTheme,

          child: Icon(
            isDark? Icons.light_mode:
            Icons.light_mode),
            ),
         SizedBox(width: 25),

      ],
     ),
    );
  }
}

// let's start form splash screen

