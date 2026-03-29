import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:runbook/firebase_options.dart';
import 'package:runbook/screens/home.dart';
import 'package:runbook/screens/unfollower_hunter.dart';
import 'package:runbook/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
