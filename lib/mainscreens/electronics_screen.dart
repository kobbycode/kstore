import 'package:flutter/material.dart';

class ElectronicsScreen extends StatefulWidget {
  const ElectronicsScreen({super.key});

  @override
  State<ElectronicsScreen> createState() => _ElectronicsScreenState();
}

class _ElectronicsScreenState extends State<ElectronicsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('ElectronicsScreen'),
      ),
    );
  }
}
