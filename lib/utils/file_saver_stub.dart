import 'dart:typed_data';
import '../services/export_service.dart';

void saveAndDownloadFile(List<int> bytes, String fileName, String mimeType) {
  if (mimeType.contains('pdf')) {
    ExportService.sharePdf(
      pdfBytes: Uint8List.fromList(bytes),
      filename: fileName,
    );
  } else {
    ExportService.shareCsv(
      csvBytes: bytes,
      filename: fileName,
    );
  }
}

void openExternalUrl(String url) {
  final Uri? uri = Uri.tryParse(url);
  final text = uri?.queryParameters['text'] ?? url;
  ExportService.shareText(text: text);
}
