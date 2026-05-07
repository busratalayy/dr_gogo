import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const DrGogoApp());
}

class DrGogoApp extends StatelessWidget {
  const DrGogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dr. Gogo',
      theme: ThemeData.dark(),
      home: const DashboardScreen(),
    );
  }
}