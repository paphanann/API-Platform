import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const EChannelHubApp());
}

class EChannelHubApp extends StatelessWidget {
  const EChannelHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Channel Hub',
      home: const LoginScreen(),
    );
  }
}