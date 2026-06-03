import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/register_screen.dart';
import 'firebase_options.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: const LoginScreen(),
    );
  }
}