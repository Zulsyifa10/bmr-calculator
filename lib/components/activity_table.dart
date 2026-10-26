// activity_table.dart
// Penanggung jawab: Anggota C
//
// Tabel dua kolom: tingkat aktivitas (kiri) dan kebutuhan kalori (kanan).
//
// ALUR:
// 1. ResultCard memberi data `needs` (label aktivitas -> kcal) dan satuan hasil.
// 2. Tabel dimulai dengan baris judul kolom.
// 3. Untuk setiap pasangan label dan nilai di `needs`, dibuat satu baris tabel.
//    Angkanya diformat oleh Calculator.formatEnergy sesuai satuan hasil.

import 'package:flutter/material.dart';
import '../calculator.dart'; // untuk Calculator.formatEnergy
import '../constants.dart'; // untuk ResultUnit

class ActivityTable extends StatelessWidget {
  const ActivityTable({super.key, required this.needs, required this.unit});

  final Map<String, double> needs; // label aktivitas -> kcal
  final ResultUnit unit; // satuan hasil

  @override
  Widget build(BuildContext context) {
    // Judul kolom kanan mengikuti satuan hasil
    final unitLabel = unit == ResultUnit.kcal ? 'Kalori' : 'Kilojoule';

    return Table(
      // Kolom kiri (aktivitas) lebih lebar daripada kolom kanan (angka)
      columnWidths: const {
        0: FlexColumnWidth(3),
        1: FlexColumnWidth(1.2),
      },
      // Garis tipis di antara baris
      border: const TableBorder(
        horizontalInside: BorderSide(color: Colors.black12),
      ),
      children: [
        // Baris judul kolom
        TableRow(
          children: [
            _cell('Tingkat aktivitas', bold: true),
            _cell(unitLabel, bold: true, right: true),
          ],
        ),
        // Satu baris per tingkat aktivitas
        for (final entry in needs.entries)
          TableRow(
            children: [
              _cell(entry.key), // label aktivitas
              // Angka kebutuhan kalori, diformat dan rata kanan
              _cell(Calculator.formatEnergy(entry.value, unit), right: true),
            ],
          ),
      ],
    );
  }

  // Sel tabel dengan padding dan perataan teks.
  // bold = huruf tebal, right = rata kanan.
  Widget _cell(String text, {bool bold = false, bool right = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        textAlign: right ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          fontSize: 13,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
