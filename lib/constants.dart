// constants.dart
// Penanggung jawab: Anggota A
//
// Alur: file ini tidak menjalankan proses apa pun. Ia hanya menyimpan nilai
// tetap yang dibaca oleh file lain:
// - calculator.dart memakai enum, konstanta konversi, dan activityLevels.
// - calculator_page.dart memakai enum dan batas usia (minAge, maxAge).
// - result_card.dart dan activity_table.dart memakai ResultUnit.
// Dengan menaruhnya di satu tempat, perubahan cukup dilakukan di sini.

// ===== Tipe enumerasi =====
// Enum = tipe data dengan pilihan terbatas, sehingga tidak ada nilai yang salah ketik.

// Jenis kelamin (dipakai rumus Mifflin dan Harris-Benedict)
enum Gender { male, female }

// Tiga rumus BMR seperti di calculator.net
enum Formula {
  mifflin, // Mifflin St Jeor
  harris, // Revised Harris-Benedict
  katch, // Katch-McArdle (butuh persentase lemak tubuh)
}

// Sistem satuan input: metrik (cm, kg) atau US (feet/inch, pound)
enum UnitSystem { metric, us }

// Satuan hasil: kalori (kcal) atau kilojoule (kJ)
enum ResultUnit { kcal, kj }

// ===== Batas input =====
// Dipakai saat validasi usia di CalculatorPage
const int minAge = 15;
const int maxAge = 80;

// ===== Konstanta konversi =====
// Semua rumus bekerja dalam cm, kg, dan kcal, jadi nilai lain dikonversi dulu.
const double kcalToKj = 4.184; // 1 kcal = 4,184 kJ
const double inchToCm = 2.54; // 1 inch = 2,54 cm
const double poundToKg = 0.45359237; // 1 pound = 0,45359237 kg

// ===== Tingkat aktivitas =====

// Satu tingkat aktivitas: label teks dan faktor pengali BMR
class ActivityLevel {
  const ActivityLevel(this.label, this.factor);

  final String label; // teks yang tampil di tabel hasil
  final double factor; // pengali BMR untuk tingkat aktivitas ini
}

// Kebutuhan kalori harian = BMR x factor (nilai sama dengan calculator.net).
// Calculator.getActivityNeeds() membaca daftar ini satu per satu.
const activityLevels = [
  ActivityLevel('Sedentary: sedikit atau tanpa olahraga', 1.2),
  ActivityLevel('Olahraga 1-3 kali/minggu', 1.375),
  ActivityLevel('Olahraga 4-5 kali/minggu', 1.465),
  ActivityLevel('Olahraga harian atau intens 3-4 kali/minggu', 1.55),
  ActivityLevel('Olahraga intens 6-7 kali/minggu', 1.725),
  ActivityLevel('Sangat intens setiap hari, atau pekerjaan fisik', 1.9),
];
