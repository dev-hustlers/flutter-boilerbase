import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_boilerbase/services/auth_service.dart';
import 'package:flutter_boilerbase/features/google_drive/presentation/screens/my_drive_documents_screen.dart';
import 'package:flutter_boilerbase/features/google_drive/presentation/providers/google_drive_providers.dart';
import 'package:flutter_boilerbase/services/revenue_cat_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // After logging in successfully, this page is shown.
    // We immediately check and show the paywall if needed!
    _checkAndShowPaywall();
  }

  void _checkAndShowPaywall() async {
    // This will only show if they don't have the "careerbridge Pro" entitlement
    await RevenueCatService.presentPaywall();
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> _simulateGenerateAndUpload(BuildContext context, WidgetRef ref, String category, String extension) async {
    try {
      ref.read(uploadProgressProvider.notifier).state = 0.0;
      
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/generated_test_$category.$extension');
      await file.writeAsString('This is a simulated generated document for $category.');

      final repository = ref.read(googleDriveRepositoryProvider);
      
      final result = await repository.uploadGeneratedDocument(file, category, onProgress: (sent, total) {
        if (total > 0) {
          ref.read(uploadProgressProvider.notifier).state = sent / total;
        }
      });

      ref.read(uploadProgressProvider.notifier).state = null;

      if (result != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Uploaded to $category successfully!')),
          );
        }
        ref.refresh(driveFilesProvider);
      }
    } catch (e) {
      ref.read(uploadProgressProvider.notifier).state = null;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating/uploading: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadProgress = ref.watch(uploadProgressProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("LOGGED IN!"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                RevenueCatService.presentCustomerCenter();
              },
              child: const Text("Manage Subscription"),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Google Drive',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MyDriveDocumentsScreen(),
                ));
              },
              icon: const Icon(Icons.cloud),
              label: const Text('Open Google Drive'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: uploadProgress != null ? null : () => _simulateGenerateAndUpload(context, ref, 'Resumes', 'pdf'),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Gen PDF'),
            ),
            if (uploadProgress != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: LinearProgressIndicator(value: uploadProgress),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
