import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_build/screens/reports/share_export_screen.dart';
import 'package:nexus_build/services/export_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ExportService Tests', () {
    test('generatePdfReport produces valid PDF byte stream', () async {
      final pdfBytes = await ExportService.generatePdfReport(
        projectName: 'Test Residence',
        location: 'Bangalore',
        area: '2,400 sq.ft',
        dateStr: '2026-08-04',
        totalCost: 1500000.0,
        concrete: 110.0,
        cement: 900.0,
        steel: 1.1,
        bricks: 50000,
        sand: 50.0,
        aggregate: 100.0,
      );

      expect(pdfBytes, isNotEmpty);
      // PDF documents start with %PDF- header magic bytes (0x25, 0x50, 0x44, 0x46, 0x2D)
      final header = ascii.decode(pdfBytes.sublist(0, 5));
      expect(header, equals('%PDF-'));
    });
  });

  group('ShareExportScreen Widget Tests', () {
    testWidgets('renders export options correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ShareExportScreen(),
        ),
      );

      expect(find.text('Share & Export'), findsWidgets);
      expect(find.text('Export as PDF'), findsOneWidget);
      expect(find.text('Export as CSV'), findsOneWidget);
      expect(find.text('Share on WhatsApp'), findsOneWidget);
    });

    testWidgets('tapping export tiles triggers share sheet handlers without error', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ShareExportScreen(),
        ),
      );

      final pdfTile = find.text('Export as PDF');
      expect(pdfTile, findsOneWidget);
      await tester.tap(pdfTile);
      await tester.pump(const Duration(milliseconds: 500));

      final csvTile = find.text('Export as CSV');
      expect(csvTile, findsOneWidget);
      await tester.tap(csvTile);
      await tester.pump(const Duration(milliseconds: 500));

      final waTile = find.text('Share on WhatsApp');
      expect(waTile, findsOneWidget);
      await tester.tap(waTile);
      await tester.pump(const Duration(milliseconds: 500));
    });
  });
}
