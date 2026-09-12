import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/home_screen.dart';
import 'screens/invoice_screen.dart';

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
      onGenerateRoute: (settings) {
        final name = settings.name ?? '';
        if (name.contains('invoice')) {
          final uri = Uri.parse(name);
          return MaterialPageRoute(
            builder: (context) => InvoiceScreen(queryParams: uri.queryParameters),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
          settings: settings,
        );
      },
    );
  }
}
