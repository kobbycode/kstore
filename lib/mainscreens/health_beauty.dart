import 'package:flutter/material.dart';

class HealthBeautyScreen extends StatefulWidget {
  const HealthBeautyScreen({super.key});

  @override
  State<HealthBeautyScreen> createState() => _HealthBeautyScreenState();
}

class _HealthBeautyScreenState extends State<HealthBeautyScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('HealthBeautyScreen'),
      ),
    );
  }
}
