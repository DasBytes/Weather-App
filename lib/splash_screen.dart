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
  final Color buttonColor = Colors.blueAccent;
@override
  void initState() {
   _timer = Timer(Duration(seconds: 3), () {
//check if the widget is still mounted before navigating
   if(mounted) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WeatherAppHomeScreen() ),
    );
   }
   });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
               Center(
                child: Text(
                  "Discover The\n Weather In Your City",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.2,
                    color:  Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const Spacer(),
              Image.asset("assets/cloudy.png", height: 350),
              const Spacer(),
               Center(
                child: Text(
                  "Get to know your weather maps\n radar recipitations forecast",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color:  Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // cancel the timer when the button is pressed to prevent the timer navigation
                    _timer.cancel();
    Navigator.pushReplacement(
      context,
     MaterialPageRoute(
      builder: (context)=> WeatherAppHomeScreen()
       ),
    );
                  },
                  child:  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    child: Text(
                      "Get started",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color:  Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
