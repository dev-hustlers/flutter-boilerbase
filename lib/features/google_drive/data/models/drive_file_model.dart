import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter_boilerbase/features/google_drive/domain/entities/drive_file.dart';

class DriveFileModel extends DriveFile {
  const DriveFileModel({
    required super.id,
    required super.name,
    super.thumbnailLink,
    super.createdTime,
    super.size,
    super.category,
    super.webViewLink,
    super.webContentLink,
  });

  factory DriveFileModel.fromDriveFile(drive.File file, {String? category}) {
    return DriveFileModel(
      id: file.id ?? '',
      name: file.name ?? '',
      thumbnailLink: file.thumbnailLink,
      createdTime: file.createdTime,
      size: int.tryParse(file.size ?? ''),
      category: category,
      webViewLink: file.webViewLink,
      webContentLink: file.webContentLink,
    );
  }
}
