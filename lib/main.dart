import 'package:flutter/material.dart';
import 'package:task1/auth/login.dart';
import 'package:task1/auth/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.alphaBlend(Colors.black87, Colors.black87)),
        useMaterial3: true,
      ),
      home: const LoginScreen( ),
    );
  }
}
