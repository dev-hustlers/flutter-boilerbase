import 'package:googleapis/drive/v3.dart' as drive;

class DriveFolderService {
  final drive.DriveApi _driveApi;
  static const _rootFolderName = 'Career App';
  
  String? _rootFolderId;
  final Map<String, String> _categoryFolderIds = {};

  DriveFolderService(this._driveApi);

  Future<String?> _getOrCreateFolder(String name, {String? parentId}) async {
    try {
      String query = "mimeType='application/vnd.google-apps.folder' and name='$name' and trashed=false";
      if (parentId != null) {
        query += " and '$parentId' in parents";
      }

      final fileList = await _driveApi.files.list(q: query, spaces: 'drive');
      if (fileList.files != null && fileList.files!.isNotEmpty) {
        return fileList.files!.first.id;
      }
      
      final folder = drive.File()
        ..name = name
        ..mimeType = 'application/vnd.google-apps.folder';
      
      if (parentId != null) {
        folder.parents = [parentId];
      }

      final createdFolder = await _driveApi.files.create(folder);
      return createdFolder.id;
    } catch (e) {
      print("Error getting/creating folder '$name': $e");
      return null;
    }
  }

  Future<String?> getRootFolderId() async {
    if (_rootFolderId != null) return _rootFolderId;
    _rootFolderId = await _getOrCreateFolder(_rootFolderName);
    return _rootFolderId;
  }

  Future<String?> getOrCreateCategoryFolder(String categoryName) async {
    if (_categoryFolderIds.containsKey(categoryName)) {
      return _categoryFolderIds[categoryName];
    }
    
    final rootId = await getRootFolderId();
    if (rootId == null) return null;

    final categoryId = await _getOrCreateFolder(categoryName, parentId: rootId);
    if (categoryId != null) {
      _categoryFolderIds[categoryName] = categoryId;
    }
    return categoryId;
  }
}
