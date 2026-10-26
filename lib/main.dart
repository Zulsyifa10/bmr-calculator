import 'package:flutter/material.dart';

// ============================================================
// KALKULATOR BMR (Basal Metabolic Rate)
// Referensi: https://www.calculator.net/bmr-calculator.html
//
// ALUR PROGRAM:
// 1. main() menjalankan aplikasi lewat runApp(BmrApp).
// 2. BmrApp membuat MaterialApp dan menampilkan BmrCalculatorPage.
// 3. Pengguna mengisi usia, jenis kelamin, tinggi, berat,
//    dan memilih rumus BMR (Mifflin-St Jeor / Harris-Benedict / Katch-McArdle).
// 4. Saat tombol "Hitung" ditekan, input divalidasi terlebih dahulu.
// 5. Jika valid, BMR dihitung sesuai rumus yang dipilih.
// 6. Hasil BMR dan kebutuhan kalori harian (BMR x faktor aktivitas)
//    ditampilkan di bagian bawah layar.
// 7. Tombol "Reset" mengosongkan semua input dan hasil.
// ============================================================

// Fungsi utama: titik awal aplikasi Flutter
void main() {
  runApp(const BmrApp());
}

// Enum untuk pilihan jenis kelamin
enum Gender { male, female }

// Enum untuk pilihan rumus BMR
enum BmrFormula { mifflin, harrisBenedict, katchMcArdle }

// Class sederhana untuk menyimpan data tingkat aktivitas
class ActivityLevel {
  final String name; // nama tingkat aktivitas
  final String description; // penjelasan singkat
  final double factor; // pengali BMR

  const ActivityLevel(this.name, this.description, this.factor);
}

// Daftar tingkat aktivitas (faktor sesuai referensi calculator.net)
const List<ActivityLevel> activityLevels = [
  ActivityLevel('Sedentary', 'Sedikit atau tanpa olahraga', 1.2),
  ActivityLevel('Ringan', 'Olahraga 1-3 hari/minggu', 1.375),
  ActivityLevel('Sedang', 'Olahraga 4-5 hari/minggu', 1.55),
  ActivityLevel('Aktif', 'Olahraga intens 6-7 hari/minggu', 1.725),
  ActivityLevel('Sangat aktif', 'Olahraga sangat berat / kerja fisik', 1.9),
];

// Widget root aplikasi
class BmrApp extends StatelessWidget {
  const BmrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator BMR',
      debugShowCheckedModeBanner: false, // sembunyikan banner "debug"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const BmrCalculatorPage(),
    );
  }
}

// Halaman kalkulator memakai StatefulWidget karena tampilan
// berubah (hasil muncul, field body fat muncul/hilang) saat pengguna berinteraksi
class BmrCalculatorPage extends StatefulWidget {
  const BmrCalculatorPage({super.key});

  @override
  State<BmrCalculatorPage> createState() => _BmrCalculatorPageState();
}

class _BmrCalculatorPageState extends State<BmrCalculatorPage> {
  // Kunci untuk mengakses dan memvalidasi Form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk membaca teks dari setiap input
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();

  // State pilihan pengguna
  Gender _gender = Gender.male;
  BmrFormula _formula = BmrFormula.mifflin;

  // Hasil perhitungan BMR (null = belum dihitung)
  double? _bmr;

  // Bersihkan controller saat halaman ditutup agar tidak boros memori
  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bodyFatController.dispose();
    super.dispose();
  }

  // Mengubah teks input menjadi angka.
  // Koma diganti titik supaya "65,5" juga terbaca sebagai 65.5
  double _parse(TextEditingController controller) {
    return double.parse(controller.text.trim().replaceAll(',', '.'));
  }

  // Validasi input: tidak boleh kosong, harus angka, dan dalam rentang wajar
  String? _validateNumber(
    String? value, {
    required String label,
    required double min,
    required double max,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$label tidak boleh kosong';
    }
    final number = double.tryParse(value.trim().replaceAll(',', '.'));
    if (number == null) {
      return '$label harus berupa angka';
    }
    if (number < min || number > max) {
      return '$label harus antara ${min.toStringAsFixed(0)} - ${max.toStringAsFixed(0)}';
    }
    return null; // null artinya input valid
  }

  // Nama rumus untuk ditampilkan di dropdown dan hasil
  String _formulaName(BmrFormula formula) {
    switch (formula) {
      case BmrFormula.mifflin:
        return 'Mifflin-St Jeor';
      case BmrFormula.harrisBenedict:
        return 'Revised Harris-Benedict';
      case BmrFormula.katchMcArdle:
        return 'Katch-McArdle';
    }
  }

  // Inti perhitungan BMR.
  // Satuan: usia (tahun), tinggi (cm), berat (kg), bodyFat (%)
  double _calculateBmr({
    required double age,
    required double height,
    required double weight,
    required double bodyFat,
  }) {
    switch (_formula) {
      // Rumus Mifflin-St Jeor
      // Pria  : 10W + 6.25H - 5A + 5
      // Wanita: 10W + 6.25H - 5A - 161
      case BmrFormula.mifflin:
        final base = (10 * weight) + (6.25 * height) - (5 * age);
        return _gender == Gender.male ? base + 5 : base - 161;

      // Rumus Revised Harris-Benedict
      // Pria  : 88.362 + 13.397W + 4.799H - 5.677A
      // Wanita: 447.593 + 9.247W + 3.098H - 4.330A
      case BmrFormula.harrisBenedict:
        if (_gender == Gender.male) {
          return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
        } else {
          return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
        }

      // Rumus Katch-McArdle
      // BMR = 370 + 21.6 x LBM, dengan LBM = berat x (1 - %lemak/100)
      // (tidak memakai usia, tinggi, atau jenis kelamin)
      case BmrFormula.katchMcArdle:
        final leanBodyMass = weight * (1 - bodyFat / 100);
        return 370 + (21.6 * leanBodyMass);
    }
  }

  // Dipanggil saat tombol "Hitung" ditekan
  void _onCalculate() {
    // Langkah 1: validasi semua input, berhenti jika ada yang salah
    if (!_formKey.currentState!.validate()) return;

    // Langkah 2: sembunyikan keyboard
    FocusScope.of(context).unfocus();

    // Langkah 3: ambil nilai input. Body fat hanya dipakai rumus Katch-McArdle
    final age = _parse(_ageController);
    final height = _parse(_heightController);
    final weight = _parse(_weightController);
    final bodyFat = _formula == BmrFormula.katchMcArdle
        ? _parse(_bodyFatController)
        : 0.0;

    // Langkah 4: hitung BMR lalu simpan ke state agar tampilan diperbarui
    setState(() {
      _bmr = _calculateBmr(
        age: age,
        height: height,
        weight: weight,
        bodyFat: bodyFat,
      );
    });
  }

  // Dipanggil saat tombol "Reset" ditekan
  void _onReset() {
    _formKey.currentState?.reset();
    _ageController.clear();
    _heightController.clear();
    _weightController.clear();
    _bodyFatController.clear();
    setState(() {
      _gender = Gender.male;
      _formula = BmrFormula.mifflin;
      _bmr = null;
    });
  }

  // Membuat satu kolom input angka dengan gaya yang seragam
  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required double min,
    required double max,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
      ),
      validator: (value) =>
          _validateNumber(value, label: label, min: min, max: max),
    );
  }

  // Tampilan kartu hasil perhitungan
  Widget _buildResult(BuildContext context) {
    final bmr = _bmr!;
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hasil BMR (${_formulaName(_formula)})',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '${bmr.toStringAsFixed(0)} kkal/hari',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Jumlah kalori minimum yang dibutuhkan tubuh saat istirahat total.',
            ),
            const Divider(height: 32),
            Text('Kebutuhan kalori harian berdasarkan aktivitas',
                style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            // Kebutuhan kalori harian = BMR x faktor aktivitas
            for (final level in activityLevels)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(level.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                          Text(level.description,
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Text(
                      '${(bmr * level.factor).toStringAsFixed(0)} kkal',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Membangun tampilan utama halaman
  @override
  Widget build(BuildContext context) {
    // Katch-McArdle tidak memakai usia, tinggi, dan jenis kelamin
    final isKatch = _formula == BmrFormula.katchMcArdle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator BMR'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pilihan rumus BMR
              DropdownButtonFormField<BmrFormula>(
                value: _formula,
                decoration: const InputDecoration(
                  labelText: 'Rumus',
                  border: OutlineInputBorder(),
                ),
                items: BmrFormula.values
                    .map((f) => DropdownMenuItem(
                          value: f,
                          child: Text(_formulaName(f)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  // Ganti rumus -> hasil lama dihapus agar tidak membingungkan
                  setState(() {
                    _formula = value;
                    _bmr = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Input usia dan tinggi (disembunyikan untuk Katch-McArdle)
              if (!isKatch) ...[
                _buildNumberField(
                  controller: _ageController,
                  label: 'Usia',
                  suffix: 'tahun',
                  min: 15,
                  max: 100,
                ),
                const SizedBox(height: 16),

                // Pilihan jenis kelamin
                SegmentedButton<Gender>(
                  segments: const [
                    ButtonSegment(
                      value: Gender.male,
                      label: Text('Pria'),
                      icon: Icon(Icons.male),
                    ),
                    ButtonSegment(
                      value: Gender.female,
                      label: Text('Wanita'),
                      icon: Icon(Icons.female),
                    ),
                  ],
                  selected: {_gender},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _gender = selection.first;
                      _bmr = null;
                    });
                  },
                ),
                const SizedBox(height: 16),

                _buildNumberField(
                  controller: _heightController,
                  label: 'Tinggi badan',
                  suffix: 'cm',
                  min: 50,
                  max: 250,
                ),
                const SizedBox(height: 16),
              ],

              // Input berat badan (dipakai semua rumus)
              _buildNumberField(
                controller: _weightController,
                label: 'Berat badan',
                suffix: 'kg',
                min: 20,
                max: 300,
              ),
              const SizedBox(height: 16),

              // Input persentase lemak tubuh (khusus Katch-McArdle)
              if (isKatch) ...[
                _buildNumberField(
                  controller: _bodyFatController,
                  label: 'Lemak tubuh',
                  suffix: '%',
                  min: 3,
                  max: 60,
                ),
                const SizedBox(height: 16),
              ],

              // Tombol Hitung dan Reset
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _onCalculate,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Hitung'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _onReset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Kartu hasil hanya muncul setelah perhitungan dilakukan
              if (_bmr != null) _buildResult(context),
            ],
          ),
        ),
      ),
    );
  }
}