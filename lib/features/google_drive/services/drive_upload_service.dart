import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'drive_folder_service.dart';

class DriveUploadService {
  final drive.DriveApi _driveApi;
  final DriveFolderService _folderService;

  DriveUploadService(this._driveApi, this._folderService);

  Future<drive.File?> uploadGeneratedFile(File file, String category, {void Function(int, int)? onProgress}) async {
    try {
      final categoryFolderId = await _folderService.getOrCreateCategoryFolder(category);
      if (categoryFolderId == null) throw Exception("Could not find or create category folder: $category");

      final driveFile = drive.File()
        ..name = p.basename(file.path)
        ..parents = [categoryFolderId];

      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      
      final length = file.lengthSync();
      final media = drive.Media(file.openRead(), length, contentType: mimeType);
      
      onProgress?.call(0, length);
      
      final result = await _driveApi.files.create(
        driveFile, 
        uploadMedia: media,
        $fields: 'id, name, createdTime, size, webViewLink, webContentLink, parents, thumbnailLink',
      );
      
      onProgress?.call(length, length);
      
      return result;
    } catch (e) {
      print("Error uploading file to $category: $e");
      return null;
    }
  }
}
