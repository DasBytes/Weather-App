import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: Padding(padding: EdgeInsets.symmetric(vertical: 40)
      child: Column(children: [
        Center(child: Text(
          "Discover The\n Weather In Your City",
          textAlign: TextAlign.center,
           style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          height: 1.2,
          color: Colors.white,

        ),),)
      ],),
      ),
      ),
    );
  }
}