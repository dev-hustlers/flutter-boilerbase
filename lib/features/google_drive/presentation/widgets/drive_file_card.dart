import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerbase/features/google_drive/domain/entities/drive_file.dart';
import 'package:flutter_boilerbase/features/google_drive/presentation/providers/google_drive_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DriveFileCard extends ConsumerWidget {
  final DriveFile file;

  const DriveFileCard({super.key, required this.file});

  String _month(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }

  Future<void> _launchUrl(String? urlStr, BuildContext context) async {
    if (urlStr == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('URL not available')));
      return;
    }
    final url = Uri.parse(urlStr);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link')));
      }
    }
  }

  Future<void> _deleteDocument(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete File?'),
        content: Text('Are you sure you want to delete ${file.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
        ],
      ),
    );
    
    if (confirm == true) {
      final repository = ref.read(googleDriveRepositoryProvider);
      final success = await repository.deleteDocument(file.id);
      if (success) {
        ref.refresh(driveFilesProvider);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete file')));
        }
      }
    }
  }

  Future<void> _downloadDocument(BuildContext context, WidgetRef ref) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final saveFile = File('${dir.path}/${file.name}');

      ref.read(downloadProgressProvider.notifier).updateProgress(file.id, 0.0);

      final repository = ref.read(googleDriveRepositoryProvider);
      final success = await repository.downloadDocument(
        file.id, 
        saveFile, 
        onProgress: (received, total) {
          if (total > 0) {
            ref.read(downloadProgressProvider.notifier).updateProgress(file.id, received / total);
          }
        }
      );

      ref.read(downloadProgressProvider.notifier).clearProgress(file.id);

      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded to ${saveFile.path}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download failed')),
          );
        }
      }
    } catch (e) {
      ref.read(downloadProgressProvider.notifier).clearProgress(file.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadProgresses = ref.watch(downloadProgressProvider);
    final progress = downloadProgresses[file.id];
    final isDownloading = progress != null;

    final dateStr = file.createdTime != null 
        ? '${file.createdTime!.day} ${_month(file.createdTime!.month)} ${file.createdTime!.year}'
        : 'Unknown Date';
        
    final sizeMb = file.size != null 
        ? (file.size! / (1024 * 1024)).toStringAsFixed(1)
        : '0.0';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    image: file.thumbnailLink != null 
                      ? DecorationImage(
                          image: NetworkImage(file.thumbnailLink!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  ),
                  child: file.thumbnailLink == null
                    ? Icon(PhosphorIcons.fileText(), size: 32)
                    : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text('Uploaded: $dateStr • $sizeMb MB', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isDownloading) ...[
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 8),
              Text(
                progress == 0.0 ? 'Downloading...' : '${(progress * 100).toStringAsFixed(0)}%',
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => _launchUrl(file.webViewLink, context),
                    icon: Icon(PhosphorIcons.eye()),
                    tooltip: 'View',
                  ),
                  IconButton(
                    onPressed: () => _downloadDocument(context, ref),
                    icon: Icon(PhosphorIcons.downloadSimple()),
                    tooltip: 'Download',
                  ),
                  IconButton(
                    onPressed: () => _launchUrl(file.webViewLink, context),
                    icon: Icon(PhosphorIcons.shareNetwork()),
                    tooltip: 'Share',
                  ),
                  IconButton(
                    onPressed: () => _deleteDocument(context, ref),
                    icon: Icon(PhosphorIcons.trash(), color: Theme.of(context).colorScheme.error),
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
