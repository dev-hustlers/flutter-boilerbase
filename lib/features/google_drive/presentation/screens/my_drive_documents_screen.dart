import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_boilerbase/features/google_drive/presentation/providers/google_drive_providers.dart';
import 'package:flutter_boilerbase/features/google_drive/presentation/widgets/drive_file_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class MyDriveDocumentsScreen extends ConsumerWidget {
  const MyDriveDocumentsScreen({super.key});

  Future<void> _pickAndUploadFile(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        
        ref.read(uploadProgressProvider.notifier).state = 0.0;
        
        final repository = ref.read(googleDriveRepositoryProvider);
        
        final uploadResult = await repository.uploadGeneratedDocument(file, 'Uploads', onProgress: (sent, total) {
          if (total > 0) {
            ref.read(uploadProgressProvider.notifier).state = sent / total;
          }
        });

        ref.read(uploadProgressProvider.notifier).state = null;

        if (uploadResult != null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Uploaded successfully!')),
            );
          }
          ref.refresh(driveFilesProvider);
        }
      }
    } catch (e) {
      ref.read(uploadProgressProvider.notifier).state = null;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driveFilesAsync = ref.watch(driveFilesProvider);
    final uploadProgress = ref.watch(uploadProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Documents'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: uploadProgress != null ? null : () => _pickAndUploadFile(context, ref),
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload to Google Drive'),
                ),
                if (uploadProgress != null) ...[
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: uploadProgress),
                ]
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: driveFilesAsync.when(
              data: (files) {
                if (files.isEmpty) {
                  return const Center(child: Text('No documents found.'));
                }
                
                final groupedFiles = <String, List>{};
                for (var f in files) {
                  final cat = f.category ?? 'Uncategorized';
                  groupedFiles.putIfAbsent(cat, () => []).add(f);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    return ref.refresh(driveFilesProvider.future);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: groupedFiles.keys.length,
                    itemBuilder: (context, index) {
                      final category = groupedFiles.keys.elementAt(index);
                      final categoryFiles = groupedFiles[category]!;
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              category,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          ...categoryFiles.map((file) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: DriveFileCard(file: file),
                          )),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error loading documents: $error', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => ref.refresh(driveFilesProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
