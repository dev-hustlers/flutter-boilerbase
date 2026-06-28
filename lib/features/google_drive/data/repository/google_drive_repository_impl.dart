import 'dart:io';
import 'package:flutter_boilerbase/features/google_drive/data/datasource/google_drive_remote_datasource.dart';
import 'package:flutter_boilerbase/features/google_drive/domain/entities/drive_file.dart';
import 'package:flutter_boilerbase/features/google_drive/domain/repository/google_drive_repository.dart';

class GoogleDriveRepositoryImpl implements GoogleDriveRepository {
  final GoogleDriveRemoteDataSource remoteDataSource;

  GoogleDriveRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<DriveFile>> listDocuments() {
    return remoteDataSource.listDocuments();
  }

  @override
  Future<DriveFile?> uploadGeneratedDocument(File file, String category, {void Function(int, int)? onProgress}) {
    return remoteDataSource.uploadGeneratedDocument(file, category, onProgress: onProgress);
  }

  @override
  Future<bool> downloadDocument(String fileId, File saveFile, {void Function(int, int)? onProgress}) {
    return remoteDataSource.downloadDocument(fileId, saveFile, onProgress: onProgress);
  }

  @override
  Future<bool> deleteDocument(String fileId) {
    return remoteDataSource.deleteDocument(fileId);
  }
}
