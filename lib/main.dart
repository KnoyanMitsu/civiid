import 'package:civiid/Layout/loginPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ke Layout/loginPage.dart kalau mau edit
    // Design ne delok en ning group.
    return MaterialApp(
      home: Loginpage(),
      theme: ThemeData(
        fontFamily: 'Manrope',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 56, 92, 221),
        ),
        useMaterial3: true,
      ),
    );
  }
}
