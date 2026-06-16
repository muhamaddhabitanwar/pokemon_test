import 'package:flutter/material.dart';
import 'package:medilink_test/core/theme/app_theme.dart';
import 'package:medilink_test/features/pokemon/screens/pokemon_list_screen.dart';

/// Developed by: Muhamad Dhabit Anwar
/// role: Flutter Developer

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M Dhabit Anwar - Medilink Test',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const PokemonListScreen(),
    );
  }
}
