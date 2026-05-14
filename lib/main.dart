import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const NailauraApp());
}

class NailauraApp extends StatelessWidget {
  const NailauraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nailaura | The Nailart Studio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
