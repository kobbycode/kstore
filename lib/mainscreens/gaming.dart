import 'package:flutter/material.dart';

class GamingScreen extends StatefulWidget {
  const GamingScreen({super.key});

  @override
  State<GamingScreen> createState() => _GamingScreenState();
}

class _GamingScreenState extends State<GamingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('GamingScreen'),
      ),
    );
  }
}
