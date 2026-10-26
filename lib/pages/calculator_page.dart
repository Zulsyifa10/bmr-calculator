// calculator_page.dart
// Penanggung jawab: Anggota B
//
// Halaman utama: form input dan hasil dalam satu halaman (seperti calculator.net).
//
// ALUR:
// 1. Saat halaman dibuka, semua kolom terisi nilai awal (contoh data).
// 2. Pengguna mengisi usia, gender, tinggi, berat (satuan metrik atau US),
//    lalu memilih rumus dan satuan hasil. Setiap pilihan memanggil setState()
//    agar tampilan diperbarui.
// 3. Tombol "Hitung" memanggil _calculate():
//    a. Membaca dan memvalidasi input (usia, tinggi, berat, lemak tubuh).
//    b. Mengubah satuan US ke metrik bila perlu.
//    c. Membuat objek Calculator dan memanggil calculateBMR().
// 4. Jika input salah, pesan error ditampilkan dan hasil lama dihapus.
//    Jika benar, ResultCard muncul di bawah tombol.
// 5. Tombol "Reset" mengembalikan semua isian ke nilai awal.

import 'package:flutter/material.dart';

import '../calculator.dart'; // logika perhitungan
import '../components/number_field.dart'; // kolom input angka
import '../components/result_card.dart'; // kotak hasil
import '../components/section_card.dart'; // kartu pembungkus form
import '../constants.dart'; // enum dan batas input

// StatefulWidget karena isi halaman berubah (pilihan, hasil, error)
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

// Class State: tempat menyimpan data yang bisa berubah
class _CalculatorPageState extends State<CalculatorPage> {
  // ===== State pilihan pengguna (nilai awal) =====
  Gender gender = Gender.male;
  UnitSystem unitSystem = UnitSystem.metric;
  Formula formula = Formula.mifflin;
  ResultUnit resultUnit = ResultUnit.kcal;

  // ===== Controller kolom input =====
  // Controller menyimpan dan membaca isi TextField. Nilai awal = contoh data.
  final ageCtrl = TextEditingController(text: '25');
  final heightCmCtrl = TextEditingController(text: '180');
  final weightKgCtrl = TextEditingController(text: '65');
  final feetCtrl = TextEditingController(text: '5');
  final inchCtrl = TextEditingController(text: '10');
  final poundCtrl = TextEditingController(text: '143');
  final bodyFatCtrl = TextEditingController(text: '20');

  // ===== State hasil =====
  Calculator? calculator; // null = belum ada hasil (ResultCard disembunyikan)
  String? errorText; // null = tidak ada error

  // Dipanggil saat halaman ditutup: bebaskan memori controller
  @override
  void dispose() {
    ageCtrl.dispose();
    heightCmCtrl.dispose();
    weightKgCtrl.dispose();
    feetCtrl.dispose();
    inchCtrl.dispose();
    poundCtrl.dispose();
    bodyFatCtrl.dispose();
    super.dispose();
  }

  // Membaca angka desimal dari kolom teks (koma dianggap titik).
  // Mengembalikan null jika isinya kosong atau bukan angka.
  double? _parse(TextEditingController c) {
    return double.tryParse(c.text.trim().replaceAll(',', '.'));
  }

  // Menampilkan pesan error dan menghapus hasil lama
  void _showError(String message) {
    setState(() {
      errorText = message;
      calculator = null;
    });
  }

  // Validasi input lalu hitung BMR. Dijalankan saat tombol "Hitung" ditekan.
  void _calculate() {
    // --- Langkah 1: validasi usia ---
    final age = int.tryParse(ageCtrl.text.trim());
    if (age == null || age < minAge || age > maxAge) {
      _showError('Usia harus diisi antara $minAge sampai $maxAge tahun.');
      return; // berhenti, jangan lanjut menghitung
    }

    // --- Langkah 2: ambil tinggi dan berat (dikonversi ke cm dan kg bila satuan US) ---
    double? heightCm;
    double? weightKg;
    if (unitSystem == UnitSystem.metric) {
      // Satuan metrik: pakai nilai apa adanya
      heightCm = _parse(heightCmCtrl);
      weightKg = _parse(weightKgCtrl);
    } else {
      // Satuan US: konversi feet/inch dan pound ke cm dan kg
      final feet = _parse(feetCtrl) ?? 0;
      final inches = _parse(inchCtrl) ?? 0;
      final pounds = _parse(poundCtrl);
      heightCm = Calculator.heightUsToCm(feet, inches);
      weightKg = pounds == null ? null : Calculator.poundToKgValue(pounds);
    }
    if (heightCm == null || heightCm <= 0) {
      _showError('Tinggi badan harus diisi dengan benar.');
      return;
    }
    if (weightKg == null || weightKg <= 0) {
      _showError('Berat badan harus diisi dengan benar.');
      return;
    }

    // --- Langkah 3: lemak tubuh (hanya untuk Katch-McArdle) ---
    double? bodyFat;
    if (formula == Formula.katch) {
      bodyFat = _parse(bodyFatCtrl);
      if (bodyFat == null || bodyFat < 1 || bodyFat > 60) {
        _showError('Lemak tubuh harus diisi antara 1 sampai 60 persen.');
        return;
      }
    }

    // --- Langkah 4: hitung ---
    // Semua input sudah valid, buat objek Calculator
    final cal = Calculator(
      age: age,
      gender: gender,
      heightCm: heightCm,
      weightKg: weightKg,
      formula: formula,
      bodyFatPercent: bodyFat,
    );
    cal.calculateBMR(); // hitung BMR, hasil disimpan di dalam objek

    // --- Langkah 5: simpan hasil dan perbarui tampilan ---
    setState(() {
      errorText = null; // hapus error lama
      calculator = cal; // ResultCard akan muncul
    });
  }

  // Mengembalikan semua isian ke nilai awal. Dijalankan saat tombol "Reset" ditekan.
  void _reset() {
    setState(() {
      gender = Gender.male;
      unitSystem = UnitSystem.metric;
      formula = Formula.mifflin;
      resultUnit = ResultUnit.kcal;
      ageCtrl.text = '25';
      heightCmCtrl.text = '180';
      weightKgCtrl.text = '65';
      feetCtrl.text = '5';
      inchCtrl.text = '10';
      poundCtrl.text = '143';
      bodyFatCtrl.text = '20';
      calculator = null; // sembunyikan hasil
      errorText = null; // hapus error
    });
  }

  // Menyusun tampilan halaman. Dipanggil ulang setiap kali setState() berjalan.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMR Calculator')),
      body: SafeArea(
        // SingleChildScrollView agar halaman bisa di-scroll di layar kecil
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Penjelasan singkat di bagian atas
              const Text(
                'Perkirakan Basal Metabolic Rate (BMR), yaitu energi yang '
                'dibutuhkan tubuh saat istirahat.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 12),

              // ----- Kartu data diri -----
              SectionCard(
                title: 'Data diri',
                children: [
                  const Text('Jenis kelamin'),
                  // Pilihan gender: saat dipilih, simpan ke variabel gender
                  SegmentedButton<Gender>(
                    segments: const [
                      ButtonSegment(
                        value: Gender.male,
                        label: Text('Laki-laki'),
                      ),
                      ButtonSegment(
                        value: Gender.female,
                        label: Text('Perempuan'),
                      ),
                    ],
                    selected: {gender},
                    onSelectionChanged: (s) => setState(() => gender = s.first),
                  ),
                  // Kolom usia (hanya angka bulat)
                  NumberField(
                    label: 'Usia ($minAge - $maxAge)',
                    suffix: 'tahun',
                    controller: ageCtrl,
                    integerOnly: true,
                  ),
                  const Text('Satuan'),
                  // Pilihan satuan: mengubah kolom tinggi dan berat di bawahnya
                  SegmentedButton<UnitSystem>(
                    segments: const [
                      ButtonSegment(
                        value: UnitSystem.metric,
                        label: Text('Metrik'),
                      ),
                      ButtonSegment(value: UnitSystem.us, label: Text('US')),
                    ],
                    selected: {unitSystem},
                    onSelectionChanged: (s) =>
                        setState(() => unitSystem = s.first),
                  ),
                  // Kolom tinggi dan berat berubah sesuai satuan yang dipilih
                  if (unitSystem == UnitSystem.metric) ...[
                    NumberField(
                      label: 'Tinggi',
                      suffix: 'cm',
                      controller: heightCmCtrl,
                    ),
                    NumberField(
                      label: 'Berat',
                      suffix: 'kg',
                      controller: weightKgCtrl,
                    ),
                  ] else ...[
                    // Satuan US: tinggi dibagi dua kolom (feet dan inch)
                    Row(
                      children: [
                        Expanded(
                          child: NumberField(
                            label: 'Tinggi',
                            suffix: 'feet',
                            controller: feetCtrl,
                            integerOnly: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: NumberField(
                            label: 'Tinggi',
                            suffix: 'inch',
                            controller: inchCtrl,
                          ),
                        ),
                      ],
                    ),
                    NumberField(
                      label: 'Berat',
                      suffix: 'pound',
                      controller: poundCtrl,
                    ),
                  ],
                ],
              ),

              // ----- Kartu pengaturan -----
              SectionCard(
                title: 'Pengaturan',
                children: [
                  // Dropdown pemilihan rumus BMR
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Rumus BMR',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Formula>(
                        value: formula,
                        isExpanded: true,
                        isDense: true,
                        items: const [
                          DropdownMenuItem(
                            value: Formula.mifflin,
                            child: Text('Mifflin St Jeor'),
                          ),
                          DropdownMenuItem(
                            value: Formula.harris,
                            child: Text('Revised Harris-Benedict'),
                          ),
                          DropdownMenuItem(
                            value: Formula.katch,
                            child: Text('Katch-McArdle'),
                          ),
                        ],
                        onChanged: (v) {
                          // v bisa null, jadi cek dulu sebelum disimpan
                          if (v != null) setState(() => formula = v);
                        },
                      ),
                    ),
                  ),
                  // Kolom lemak tubuh hanya muncul untuk Katch-McArdle
                  if (formula == Formula.katch)
                    NumberField(
                      label: 'Lemak tubuh',
                      suffix: '%',
                      controller: bodyFatCtrl,
                    ),
                  const Text('Satuan hasil'),
                  // Pilihan satuan hasil: kalori atau kilojoule
                  SegmentedButton<ResultUnit>(
                    segments: const [
                      ButtonSegment(
                        value: ResultUnit.kcal,
                        label: Text('Kalori'),
                      ),
                      ButtonSegment(
                        value: ResultUnit.kj,
                        label: Text('Kilojoule'),
                      ),
                    ],
                    selected: {resultUnit},
                    onSelectionChanged: (s) =>
                        setState(() => resultUnit = s.first),
                  ),
                ],
              ),

              // ----- Pesan error (hanya tampil jika errorText tidak null) -----
              if (errorText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    errorText!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),

              // ----- Tombol Hitung dan Reset -----
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _calculate, // jalankan validasi dan hitung
                      child: const Text('Hitung'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _reset, // kembalikan ke nilai awal
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              ),

              // ----- Hasil (muncul setelah Hitung berhasil) -----
              if (calculator != null) ...[
                const SizedBox(height: 16),
                // Data hasil diambil dari objek Calculator lalu diberikan ke ResultCard
                ResultCard(
                  bmrKcal: calculator!.bmr,
                  formulaName: calculator!.getFormulaName(),
                  activityNeeds: calculator!.getActivityNeeds(),
                  unit: resultUnit,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
