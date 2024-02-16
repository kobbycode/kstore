import 'package:flutter/material.dart';
import 'package:kobby_store/mainscreens/appliances_screen.dart';
import 'package:kobby_store/mainscreens/computing_screen.dart';
import 'package:kobby_store/mainscreens/customer_main_screen.dart';
import 'package:kobby_store/mainscreens/electronics_screen.dart';
import 'package:kobby_store/mainscreens/gaming.dart';
import 'package:kobby_store/mainscreens/health_beauty.dart';
import 'package:kobby_store/mainscreens/home_office.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kobby Store',
      initialRoute: '/home', // Set the initial route
      routes: {
        '/home': (context) => const CustomerMainScreen(),
        '/electronics': (context) => const ElectronicsScreen(),
        '/appliances': (context) => const AppliancesScreen(),
        '/computing': (context) => const ComputingScreen(),
        '/gaming': (context) => const GamingScreen(),
        '/healthBeauty': (context) => const HealthBeautyScreen(),
        '/homeOffice': (context) => const HomeOfficeScreen(),

        // Add more routes as needed
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
