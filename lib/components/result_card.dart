// result_card.dart
// Penanggung jawab: Anggota C
//
// Kotak hasil berlatar hijau muda.
//
// ALUR:
// 1. CalculatorPage memberi BMR (kcal), nama rumus, kebutuhan per aktivitas,
//    dan satuan hasil, setelah perhitungan berhasil.
// 2. ResultCard memformat BMR sesuai satuan (kalori atau kilojoule) lewat
//    Calculator.formatEnergy, lalu menampilkannya dalam angka besar.
// 3. Tabel kebutuhan kalori per aktivitas ditampilkan oleh ActivityTable.

import 'package:flutter/material.dart';

import '../calculator.dart'; // untuk Calculator.formatEnergy
import '../constants.dart'; // untuk ResultUnit
import 'activity_table.dart'; // tabel aktivitas

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.bmrKcal,
    required this.formulaName,
    required this.activityNeeds,
    required this.unit,
  });

  final double bmrKcal; // BMR dalam kcal/hari
  final String formulaName; // nama rumus yang dipakai
  final Map<String, double> activityNeeds; // label aktivitas -> kcal
  final ResultUnit unit; // satuan hasil yang dipilih

  @override
  Widget build(BuildContext context) {
    // Teks satuan di belakang angka BMR
    final unitText = unit == ResultUnit.kcal ? 'kalori/hari' : 'kJ/hari';

    return Container(
      padding: const EdgeInsets.all(16),
      // Latar hijau muda dengan garis tepi hijau
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        border: Border.all(color: const Color(0xFFA5D6A7)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul kotak hasil
          const Text(
            'Hasil',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Satu baris teks dengan bagian berbeda gaya: "BMR = 1.655 kalori/hari"
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'BMR = '),
                // Angka BMR dibuat besar, tebal, dan hijau tua
                TextSpan(
                  text: Calculator.formatEnergy(bmrKcal, unit),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                TextSpan(text: ' $unitText'),
              ],
            ),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          // Nama rumus yang dipakai
          Text(
            'Rumus: $formulaName',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          const Text(
            'Kebutuhan kalori harian berdasarkan tingkat aktivitas',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Tabel kebutuhan kalori per aktivitas
          ActivityTable(needs: activityNeeds, unit: unit),
          const SizedBox(height: 12),
          // Catatan bahwa hasil hanya perkiraan
          const Text(
            'Hasil hanya perkiraan dari rumus statistik, bukan pengganti '
            'saran tenaga kesehatan.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
