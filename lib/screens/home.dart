import 'package:flutter/material.dart';
import 'package:runbook/screens/dashboard.dart';
import 'package:runbook/screens/settings.dart';
import 'package:runbook/widgets/navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  void handleTabChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget renderScreen(int page) {
    switch (page) {
      case 1:
        return SettingScreen();
      default:
        return DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: renderScreen(currentIndex),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: currentIndex,
        onTabChanged: handleTabChange,
      ),
    );
  }
}
