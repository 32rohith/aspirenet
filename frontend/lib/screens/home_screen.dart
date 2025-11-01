import 'package:flutter/material.dart';
import 'main_navigation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Redirect to main navigation with dashboard as default
    return const MainNavigationScreen(initialIndex: 0);
  }
}

