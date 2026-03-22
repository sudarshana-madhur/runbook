import 'package:flutter/material.dart';
import 'package:runbook/screens/home.dart';
import 'package:runbook/screens/unfollower_hunter.dart';
import 'package:runbook/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runbook',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/unfollower-hunter': (context) => const UnfollowerHunterScreen(),
      },
    );
  }
}
