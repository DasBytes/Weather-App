import 'package:flutter/material.dart';

class WeatherAppHomeScreen extends StatefulWidget {
  const WeatherAppHomeScreen({super.key});

  @override
  State<WeatherAppHomeScreen> createState() => _WeatherAppHomeScreenState();
}

class _WeatherAppHomeScreenState extends State<WeatherAppHomeScreen> {
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
        GestureDetector(child: Icon(Icons.light_mode)),
      ],
     ),
    );
  }
}

// let's start form splash screen

