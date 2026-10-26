// widget_test.dart
// Penanggung jawab: Anggota B
//
// Widget test untuk halaman kalkulator: hasil muncul setelah tombol Hitung,
// dan pesan error muncul jika usia di luar rentang. Jalankan: flutter test

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bmr_calculator/main.dart';

void main() {
  testWidgets('Hasil muncul setelah tombol Hitung ditekan', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Awalnya belum ada hasil
    expect(find.text('Hasil'), findsNothing);

    await tester.ensureVisible(find.text('Hitung'));
    await tester.tap(find.text('Hitung'));
    await tester.pump();

    expect(find.text('Hasil'), findsOneWidget);
  });

  testWidgets('Usia di luar rentang menampilkan pesan error', (tester) async {
    await tester.pumpWidget(const MyApp());

    // TextField pertama adalah kolom usia
    await tester.enterText(find.byType(TextField).first, '10');

    await tester.ensureVisible(find.text('Hitung'));
    await tester.tap(find.text('Hitung'));
    await tester.pump();

    expect(
      find.text('Usia harus diisi antara 15 sampai 80 tahun.'),
      findsOneWidget,
    );
    expect(find.text('Hasil'), findsNothing);
  });
}
