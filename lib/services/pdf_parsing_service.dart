import 'dart:io';
import 'package:read_pdf_text/read_pdf_text.dart';

class PdfParsingService {
  /// Extracts plain text from the PDF at the given [filePath].
  /// Throws [FormatException] if the PDF is corrupt or empty.
  /// Throws [FileNotFoundException] if the file does not exist.
  Future<String> extractText(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileNotFoundException("PDF file not found at: $filePath");
    }

    try {
      // getPDFtext(path) parses PDF box on Android and PDFKit on iOS.
      final text = await ReadPdfText.getPDFtext(filePath);
      
      if (text.trim().isEmpty) {
        throw const FormatException("The selected PDF file appears to be empty or contains no extractable text.");
      }
      
      return text;
    } catch (e) {
      throw FormatException("Failed to read PDF structure: ${e.toString()}");
    }
  }
}

class FileNotFoundException implements Exception {
  final String message;
  FileNotFoundException(this.message);
  @override
  String toString() => "FileNotFoundException: $message";
}
