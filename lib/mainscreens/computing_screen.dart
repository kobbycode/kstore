import 'package:flutter/material.dart';

class ComputingScreen extends StatefulWidget {
  const ComputingScreen({super.key});

  @override
  State<ComputingScreen> createState() => _ComputingScreenState();
}

class _ComputingScreenState extends State<ComputingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ComputingScreen'),
      ),
    );
  }
}
