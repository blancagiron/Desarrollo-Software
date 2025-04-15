import 'package:flutter/material.dart';
import 'widgets/selector_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Selector de LLM - Hugging Face',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
        ),
      ),
      home: const LLMSelectorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}