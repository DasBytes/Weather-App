import 'package:flutter/material.dart';

class AboutHelpPage extends StatelessWidget {
  const AboutHelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About / Help")),
      body: const Center(child: Text("About and help page")),
    );
  }
}
