// calculator_test.dart
// Penanggung jawab: Anggota A
//
// Unit test untuk logika perhitungan (rumus BMR, kebutuhan aktivitas,
// konversi satuan, dan format angka). Jalankan dengan: flutter test

import 'package:flutter_test/flutter_test.dart';
import 'package:bmr_calculator/calculator.dart';
import 'package:bmr_calculator/constants.dart';

void main() {
  group('Rumus BMR', () {
    test('Mifflin St Jeor pria: 25 tahun, 180 cm, 80 kg = 1805', () {
      final cal = Calculator(
        age: 25,
        gender: Gender.male,
        heightCm: 180,
        weightKg: 80,
        formula: Formula.mifflin,
      );
      expect(cal.calculateBMR(), closeTo(1805, 0.001));
    });

    test('Mifflin St Jeor wanita: 30 tahun, 165 cm, 60 kg = 1320,25', () {
      final cal = Calculator(
        age: 30,
        gender: Gender.female,
        heightCm: 165,
        weightKg: 60,
        formula: Formula.mifflin,
      );
      expect(cal.calculateBMR(), closeTo(1320.25, 0.001));
    });

    test('Harris-Benedict pria: 25 tahun, 180 cm, 80 kg = 1882,017', () {
      final cal = Calculator(
        age: 25,
        gender: Gender.male,
        heightCm: 180,
        weightKg: 80,
        formula: Formula.harris,
      );
      expect(cal.calculateBMR(), closeTo(1882.017, 0.001));
    });

    test('Harris-Benedict wanita: 30 tahun, 165 cm, 60 kg = 1383,683', () {
      final cal = Calculator(
        age: 30,
        gender: Gender.female,
        heightCm: 165,
        weightKg: 60,
        formula: Formula.harris,
      );
      expect(cal.calculateBMR(), closeTo(1383.683, 0.001));
    });

    test('Katch-McArdle: 80 kg, lemak tubuh 20% = 1752,4', () {
      final cal = Calculator(
        age: 25,
        gender: Gender.male,
        heightCm: 180,
        weightKg: 80,
        formula: Formula.katch,
        bodyFatPercent: 20,
      );
      expect(cal.calculateBMR(), closeTo(1752.4, 0.001));
    });
  });

  group('Kebutuhan kalori per aktivitas', () {
    test('BMR 1805 dikali faktor aktivitas', () {
      final cal = Calculator(
        age: 25,
        gender: Gender.male,
        heightCm: 180,
        weightKg: 80,
        formula: Formula.mifflin,
      );
      cal.calculateBMR();
      final needs = cal.getActivityNeeds();

      expect(needs.length, activityLevels.length);
      expect(needs.values.first, closeTo(1805 * 1.2, 0.001));
      expect(needs.values.last, closeTo(1805 * 1.9, 0.001));
    });
  });

  group('Konversi satuan dan format', () {
    test('feet dan inch ke cm', () {
      expect(Calculator.heightUsToCm(5, 10), closeTo(177.8, 0.001));
    });

    test('pound ke kg', () {
      expect(Calculator.poundToKgValue(143), closeTo(64.8637, 0.001));
    });

    test('formatEnergy kalori memakai pemisah ribuan', () {
      expect(Calculator.formatEnergy(1655.4, ResultUnit.kcal), '1.655');
      expect(Calculator.formatEnergy(999, ResultUnit.kcal), '999');
      expect(Calculator.formatEnergy(1234567, ResultUnit.kcal), '1.234.567');
    });

    test('formatEnergy kilojoule dikonversi dari kalori', () {
      // 1655 kcal x 4,184 = 6924,52 -> 6925
      expect(Calculator.formatEnergy(1655, ResultUnit.kj), '6.925');
    });
  });
}
