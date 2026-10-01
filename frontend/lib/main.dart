import 'package:flutter/material.dart';
import 'screens/ingredient_screen.dart';

void main() {
  runApp(const EcoEatApp());
}

class EcoEatApp extends StatelessWidget {
  const EcoEatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoEat - Chef Virtual Anti-Desperdicio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0F766E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          primary: const Color(0xFF0F766E),
          secondary: const Color(0xFF10B981),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Color(0xFF0F766E),
          foregroundColor: Colors.white,
        ),
      ),
      home: const IngredientScreen(),
    );
  }
}
