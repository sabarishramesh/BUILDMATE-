import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/app_formatter.dart';

class ExportService {
  /// Generates a PDF report as Uint8List using the printing/pdf package.
  static Future<Uint8List> generatePdfReport({
    required String projectName,
    required String location,
    required String area,
    required String dateStr,
    required double totalCost,
    required double concrete,
    required double cement,
    required double steel,
    required int bricks,
    required double sand,
    required double aggregate,
  }) async {
    final pdf = pw.Document();
    final fmt = NumberFormat('#,##,###');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'BUILDMATE CONSTRUCTION ESTIMATE REPORT',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        dateStr,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Project Information',
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text('Project Name: $projectName'),
                pw.Text('Location: $location'),
                pw.Text('Built-Up Area: $area'),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Estimated Material & Quantity Breakdown',
                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.TableHelper.fromTextArray(
                  headers: ['Item Description', 'Quantity', 'Unit'],
                  data: [
                    ['Concrete Volume', AppFormatter.formatVolume(concrete, unit: ''), 'm3'],
                    ['Cement Bags', AppFormatter.formatCement(cement).replaceAll(' bags', ''), 'bags'],
                    ['Steel Tonnage', AppFormatter.formatSteel(steel).replaceAll(' MT', ''), 'MT'],
                    ['Bricks Count', AppFormatter.formatBricks(bricks, unit: '').trim(), 'nos'],
                    ['Sand Volume', AppFormatter.formatVolume(sand, unit: ''), 'm3'],
                    ['Aggregate Volume', AppFormatter.formatVolume(aggregate, unit: ''), 'm3'],
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  cellAlignment: pw.Alignment.centerLeft,
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(width: 1, color: PdfColors.black),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'TOTAL ESTIMATED COST:',
                        style: pw.TextStyle(
                          fontSize: 13,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Rs ${AppFormatter.formatCostRaw(totalCost)}',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Spacer(),
                pw.Divider(),
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'Generated via BuildMate Estimator App',
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Exports PDF using Printing.sharePdf() to open native share sheet.
  static Future<void> sharePdf({
    required Uint8List pdfBytes,
    required String filename,
  }) async {
    await Printing.sharePdf(bytes: pdfBytes, filename: filename);
  }

  /// Exports CSV by writing to a temporary file and sharing via share_plus.
  static Future<void> shareCsv({
    required List<int> csvBytes,
    required String filename,
  }) async {
    if (kIsWeb) {
      await Share.shareXFiles(
        [
          XFile.fromData(
            Uint8List.fromList(csvBytes),
            name: filename,
            mimeType: 'text/csv',
          ),
        ],
        text: 'BuildMate Estimate CSV Report',
      );
    } else {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$filename';
      final file = File(filePath);
      await file.writeAsBytes(csvBytes);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv')],
        text: 'BuildMate Estimate CSV Report',
      );
    }
  }

  /// Shares text (e.g. WhatsApp summary) via share_plus.
  static Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    await Share.share(text, subject: subject);
  }
}
