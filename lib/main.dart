// main.dart
// Penanggung jawab: Anggota B
//
// Titik awal aplikasi. Alur:
// 1. main() menjalankan MyApp lewat runApp().
// 2. MyApp membuat MaterialApp dengan tema terang berwarna hijau.
// 3. Halaman yang tampil adalah CalculatorPage (form dan hasil dalam satu halaman).

import 'package:flutter/material.dart';
import 'pages/calculator_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMR Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF4F7F4),
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const CalculatorPage(),
    );
  }
}
