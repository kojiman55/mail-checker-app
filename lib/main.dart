import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MailCheckerApp());
}

class MailCheckerApp extends StatelessWidget {
  const MailCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MailChecker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6d28d9),
        ),
        useMaterial3: true,
      ),
      home: const MailCheckerHome(),
    );
  }
}
