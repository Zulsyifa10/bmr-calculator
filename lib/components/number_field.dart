// number_field.dart
// Penanggung jawab: Anggota B
//
// Kolom input angka dengan label dan satuan (suffix).
//
// ALUR:
// 1. CalculatorPage membuat NumberField dan memberinya controller.
// 2. Saat pengguna mengetik, FilteringTextInputFormatter menolak karakter
//    selain angka (dan titik/koma untuk desimal).
// 3. Isi kolom dibaca kembali oleh CalculatorPage lewat controller.text.
// integerOnly = true hanya menerima angka bulat (mis. usia dan feet).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // untuk inputFormatters

class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.label,
    required this.controller,
    this.suffix,
    this.integerOnly = false,
  });

  final String label; // teks label di atas kolom
  final TextEditingController controller; // menyimpan isi kolom
  final String? suffix; // satuan di ujung kanan (cm, kg, dan sebagainya)
  final bool integerOnly; // true = hanya angka bulat

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      // Tampilkan keyboard angka (dengan tombol desimal jika bukan integerOnly)
      keyboardType: TextInputType.numberWithOptions(decimal: !integerOnly),
      // Hanya izinkan karakter angka (dan titik/koma untuk desimal)
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(integerOnly ? r'[0-9]' : r'[0-9.,]'),
        ),
      ],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
