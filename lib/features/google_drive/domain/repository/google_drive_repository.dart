import 'dart:io';
import 'package:flutter_boilerbase/features/google_drive/domain/entities/drive_file.dart';

abstract class GoogleDriveRepository {
  Future<List<DriveFile>> listDocuments();
  Future<DriveFile?> uploadGeneratedDocument(File file, String category, {void Function(int sent, int total)? onProgress});
  Future<bool> downloadDocument(String fileId, File saveFile, {void Function(int received, int total)? onProgress});
  Future<bool> deleteDocument(String fileId);
}
