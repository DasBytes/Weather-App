import 'package:flutter/material.dart';

class FavoriteCitiesPage extends StatelessWidget {
  const FavoriteCitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Cities")),
      body: const Center(child: Text("Favorite cities list")),
    );
  }
}
