// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void saveAndDownloadFile(List<int> bytes, String fileName, String mimeType) {
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..style.display = 'none';
  html.document.body?.children.add(anchor);
  anchor.click();
  anchor.remove();
  html.Url.revokeObjectUrl(url);
}

void openExternalUrl(String url) {
  html.window.open(url, '_blank');
}
