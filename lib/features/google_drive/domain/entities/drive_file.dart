class DriveFile {
  final String id;
  final String name;
  final String? thumbnailLink;
  final DateTime? createdTime;
  final int? size;
  final String? category;
  final String? webViewLink;
  final String? webContentLink;

  const DriveFile({
    required this.id,
    required this.name,
    this.thumbnailLink,
    this.createdTime,
    this.size,
    this.category,
    this.webViewLink,
    this.webContentLink,
  });
}
