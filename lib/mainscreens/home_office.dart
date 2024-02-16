import 'package:flutter/material.dart';

class HomeOfficeScreen extends StatefulWidget {
  const HomeOfficeScreen({super.key});

  @override
  State<HomeOfficeScreen> createState() => _HomeOfficeScreenState();
}

class _HomeOfficeScreenState extends State<HomeOfficeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('HomeOfficeScreen'),
      ),
    );
  }
}
