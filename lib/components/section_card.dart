// section_card.dart
// Penanggung jawab: Anggota C
//
// Kartu putih dengan judul, dipakai untuk mengelompokkan bagian form.
//
// ALUR:
// 1. CalculatorPage memberi judul dan daftar widget (children).
// 2. SectionCard menampilkan judul, lalu menyusun semua children
//    secara vertikal dengan jarak 12 piksel di antaranya.

import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.title, required this.children});

  final String title; // judul kartu, mis. "Data diri"
  final List<Widget> children; // isi kartu

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0, // tanpa bayangan
      margin: const EdgeInsets.only(bottom: 12), // jarak ke kartu berikutnya
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // sudut membulat
        side: const BorderSide(color: Colors.black12), // garis tepi tipis
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Judul kartu
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Untuk setiap child: beri jarak 12 piksel di atasnya, lalu tampilkan
            for (final child in children) ...[
              const SizedBox(height: 12),
              child,
            ],
          ],
        ),
      ),
    );
  }
}
