// main.dart
// Penanggung jawab: Anggota B
//
// ============================================================
// ALUR PROGRAM KESELURUHAN
// ============================================================
// 1. Aplikasi dimulai dari fungsi main() di file ini.
// 2. main() memanggil runApp() untuk menampilkan widget MyApp.
// 3. MyApp membangun MaterialApp: mengatur tema dan halaman awal.
// 4. Halaman awal adalah CalculatorPage (lib/pages/calculator_page.dart).
// 5. Pengguna mengisi form, lalu menekan tombol "Hitung".
//    CalculatorPage membaca dan memvalidasi input, lalu membuat objek
//    Calculator (lib/calculator.dart).
// 6. Calculator menghitung BMR dengan rumus yang dipilih, lalu menghitung
//    kebutuhan kalori harian untuk tiap tingkat aktivitas.
// 7. Hasilnya ditampilkan oleh ResultCard (lib/components/result_card.dart)
//    yang memakai ActivityTable untuk tabel aktivitas.
// 8. constants.dart menyimpan enum, batas input, dan faktor aktivitas yang
//    dipakai oleh semua file di atas.
// ============================================================

import 'package:flutter/material.dart'; // library widget Material Design
import 'pages/calculator_page.dart'; // halaman utama aplikasi

// Fungsi pertama yang dijalankan saat aplikasi dibuka
void main() {
  // runApp memasang MyApp sebagai widget paling atas (root)
  runApp(const MyApp());
}

// Widget root aplikasi. StatelessWidget karena tidak menyimpan data yang berubah.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Membuat skema warna otomatis dari satu warna dasar (hijau)
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32));

    return MaterialApp(
      debugShowCheckedModeBanner: false, // sembunyikan label "DEBUG" di pojok
      title: 'BMR Calculator', // judul aplikasi
      theme: ThemeData(
        useMaterial3: true, // pakai desain Material 3
        colorScheme: scheme,
        scaffoldBackgroundColor: const Color(0xFFF4F7F4), // latar halaman
        // Gaya AppBar: hijau dengan teks putih di tengah
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      // Halaman pertama yang tampil saat aplikasi dibuka
      home: const CalculatorPage(),
    );
  }
}
