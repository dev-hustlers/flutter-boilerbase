import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter_boilerbase/features/google_drive/data/models/drive_file_model.dart';
import 'package:flutter_boilerbase/features/google_drive/services/google_auth_client.dart';
import 'package:flutter_boilerbase/features/google_drive/services/drive_folder_service.dart';
import 'package:flutter_boilerbase/features/google_drive/services/drive_upload_service.dart';
import 'package:flutter_boilerbase/services/auth_service.dart';

class GoogleDriveRemoteDataSource {
  DriveFolderService? _folderService;
  DriveUploadService? _uploadService;
  drive.DriveApi? _driveApi;

  Future<void> _initServices() async {
    if (_driveApi != null) return;
    final user = await AuthService().getGoogleUser();
    if (user == null) throw Exception("User not authenticated with Google");
    final headers = await user.authHeaders;
    final client = GoogleAuthClient(headers);
    _driveApi = drive.DriveApi(client);
    _folderService = DriveFolderService(_driveApi!);
    _uploadService = DriveUploadService(_driveApi!, _folderService!);
  }

  Future<List<DriveFileModel>> listDocuments() async {
    await _initServices();
    
    final rootId = await _folderService!.getRootFolderId();
    if (rootId == null) throw Exception("Failed to find root folder");

    final categories = ['Resumes', 'Cover Letters', 'ATS Reports', 'Images', 'Certificates'];
    final List<DriveFileModel> allFiles = [];

    for (final category in categories) {
      final categoryId = await _folderService!.getOrCreateCategoryFolder(category);
      if (categoryId != null) {
        final query = "'$categoryId' in parents and trashed=false";
        final fileList = await _driveApi!.files.list(
          q: query,
          spaces: 'drive',
          $fields: 'files(id, name, createdTime, size, webViewLink, webContentLink, parents, thumbnailLink)',
        );
        if (fileList.files != null) {
          for (final file in fileList.files!) {
            allFiles.add(DriveFileModel.fromDriveFile(file, category: category));
          }
        }
      }
    }
    
    return allFiles;
  }

  Future<DriveFileModel?> uploadGeneratedDocument(File file, String category, {void Function(int, int)? onProgress}) async {
    await _initServices();
    final result = await _uploadService!.uploadGeneratedFile(file, category, onProgress: onProgress);
    if (result == null) return null;
    return DriveFileModel.fromDriveFile(result, category: category);
  }

  Future<bool> downloadDocument(String fileId, File saveFile, {void Function(int, int)? onProgress}) async {
    await _initServices();
    
    try {
      final meta = await _driveApi!.files.get(fileId, $fields: 'size') as drive.File;
      final totalSize = int.tryParse(meta.size ?? '0') ?? 0;

      final media = await _driveApi!.files.get(fileId,
          downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

      final List<int> dataStore = [];
      int downloaded = 0;
      await for (final element in media.stream) {
        dataStore.addAll(element);
        downloaded += element.length;
        if (totalSize > 0) {
          onProgress?.call(downloaded, totalSize);
        }
      }

      await saveFile.writeAsBytes(dataStore);
      return true;
    } catch (e) {
      print("Error downloading file: $e");
      return false;
    }
  }

  Future<bool> deleteDocument(String fileId) async {
    await _initServices();
    try {
      await _driveApi!.files.delete(fileId);
      return true;
    } catch (e) {
      print("Error deleting file: $e");
      return false;
    }
  }
}
