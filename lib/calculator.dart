// calculator.dart
// Penanggung jawab: Anggota A
//
// Class Calculator berisi seluruh logika perhitungan (tanpa tampilan).
//
// ALUR:
// 1. CalculatorPage membuat objek Calculator dengan data yang sudah divalidasi
//    (semua dalam satuan metrik: cm dan kg).
// 2. calculateBMR() memilih rumus berdasarkan `formula`, menghitung BMR
//    (kcal/hari), dan menyimpannya di variabel _bmr.
// 3. getActivityNeeds() mengalikan _bmr dengan faktor tiap tingkat aktivitas.
// 4. getFormulaName() memberi nama rumus untuk ditampilkan di hasil.
// 5. Fungsi static membantu konversi satuan US dan format angka. Fungsi static
//    dipanggil lewat nama class (Calculator.formatEnergy) tanpa membuat objek.

import 'constants.dart';

class Calculator {
  // Constructor: semua data wajib diisi, kecuali bodyFatPercent (opsional)
  Calculator({
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    required this.formula,
    this.bodyFatPercent,
  });

  final int age; // usia dalam tahun
  final Gender gender; // jenis kelamin
  final double heightCm; // tinggi dalam cm
  final double weightKg; // berat dalam kg
  final Formula formula; // rumus yang dipilih pengguna
  final double?
  bodyFatPercent; // hanya dipakai rumus Katch-McArdle (boleh null)

  // Menyimpan hasil BMR. Awalnya 0 sampai calculateBMR() dipanggil.
  double _bmr = 0.0;

  // Getter agar file lain bisa membaca BMR, tetapi tidak bisa mengubahnya
  double get bmr => _bmr;

  // Menghitung BMR dalam kcal/hari.
  // W = berat (kg), H = tinggi (cm), A = usia (tahun), F = lemak tubuh (pecahan)
  double calculateBMR() {
    final w = weightKg;
    final h = heightCm;
    final a = age.toDouble();

    // Pilih rumus sesuai pilihan pengguna
    switch (formula) {
      case Formula.mifflin:
        // Pria ditambah 5, wanita dikurangi 161
        _bmr = 10 * w + 6.25 * h - 5 * a + (gender == Gender.male ? 5 : -161);
        break;
      case Formula.harris:
        // Koefisien berbeda untuk pria dan wanita
        if (gender == Gender.male) {
          _bmr = 13.397 * w + 4.799 * h - 5.677 * a + 88.362;
        } else {
          _bmr = 9.247 * w + 3.098 * h - 4.330 * a + 447.593;
        }
        break;
      case Formula.katch:
        // Memakai massa tubuh tanpa lemak, jadi tidak butuh gender/tinggi/usia
        final f = (bodyFatPercent ?? 0) / 100; // persen -> pecahan
        _bmr = 370 + 21.6 * (1 - f) * w;
        break;
    }
    return _bmr;
  }

  // Nama rumus untuk ditampilkan di kotak hasil
  String getFormulaName() {
    switch (formula) {
      case Formula.mifflin:
        return 'Mifflin St Jeor';
      case Formula.harris:
        return 'Revised Harris-Benedict';
      case Formula.katch:
        return 'Katch-McArdle';
    }
  }

  // Kebutuhan kalori harian (kcal) untuk setiap tingkat aktivitas.
  // Key = label aktivitas, value = kcal per hari.
  // Harus dipanggil setelah calculateBMR().
  Map<String, double> getActivityNeeds() {
    final result = <String, double>{};
    // Ulangi untuk setiap tingkat aktivitas di constants.dart
    for (final level in activityLevels) {
      result[level.label] = _bmr * level.factor; // BMR x faktor aktivitas
    }
    return result;
  }

  // ===== Fungsi bantu (static) =====

  // Mengubah feet + inch menjadi cm (1 feet = 12 inch)
  static double heightUsToCm(double feet, double inches) {
    return (feet * 12 + inches) * inchToCm;
  }

  // Mengubah pound menjadi kg
  static double poundToKgValue(double pounds) {
    return pounds * poundToKg;
  }

  // Mengubah kcal ke teks sesuai satuan hasil, dibulatkan, dengan pemisah ribuan.
  // Contoh: 1655.4 kcal -> "1.655"
  static String formatEnergy(double kcal, ResultUnit unit) {
    // Jika satuan kJ, kalikan 4,184; lalu bulatkan ke bilangan bulat
    final value = (unit == ResultUnit.kj ? kcal * kcalToKj : kcal).round();
    // Sisipkan titik setiap tiga digit dari belakang
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }
}
