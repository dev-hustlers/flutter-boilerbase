import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:catalyst/l10n/app_localizations.dart';
import '../../../../core/providers/service_providers.dart';
import '../../view_model/onboarding_view_model.dart';
import '../../../main_screen/view/main_screen.dart';

class ResumeUploadStep extends ConsumerStatefulWidget {
  final Function(bool isPaused) onProgressLockChange;
  final VoidCallback onUploadComplete;

  const ResumeUploadStep({
    super.key,
    required this.onProgressLockChange,
    required this.onUploadComplete,
  });

  @override
  ConsumerState<ResumeUploadStep> createState() => _ResumeUploadStepState();
}

class _ResumeUploadStepState extends ConsumerState<ResumeUploadStep> {
  bool _isPickingOrParsing = false;
  String? _errorMessage;

  Future<void> _pickResume() async {
    setState(() {
      _isPickingOrParsing = true;
      _errorMessage = null;
    });
    // Pause auto-advance story timer
    widget.onProgressLockChange(true);

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        setState(() {
          _isPickingOrParsing = false;
        });
        widget.onProgressLockChange(false);
        return;
      }

      final filePath = result.files.single.path!;
      final pdfParser = ref.read(pdfParsingServiceProvider);

      // Extract raw text
      final extractedText = await pdfParser.extractText(filePath);

      ref.read(onboardingViewModelProvider.notifier).setResume(filePath, extractedText);

      if (mounted) {
        setState(() {
          _isPickingOrParsing = false;
        });
        widget.onUploadComplete();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll("FormatException: ", "");
          _isPickingOrParsing = false;
        });
      }
      widget.onProgressLockChange(true); // Keep it locked since there's an error to fix
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final onboardingState = ref.watch(onboardingViewModelProvider);
    final hasResume = onboardingState.resumePath != null;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.uploadResume,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.privateLocalPdfParsing,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // File Selector Box
          InkWell(
            onTap: _isPickingOrParsing ? null : _pickResume,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: hasResume 
                    ? theme.colorScheme.primaryContainer.withAlpha(25)
                    : theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: hasResume 
                      ? theme.colorScheme.primary.withAlpha(150)
                      : theme.colorScheme.outline.withAlpha(50),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    hasResume ? LucideIcons.fileCheck2 : LucideIcons.fileUp,
                    size: 64,
                    color: hasResume ? theme.colorScheme.primary : theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  if (_isPickingOrParsing) ...[
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Parsing PDF contents...",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ] else if (hasResume) ...[
                    Text(
                      l10n.resumeSuccessLoaded,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      onboardingState.resumePath!.split('/').last,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${(onboardingState.resumeText?.length ?? 0)} characters extracted",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ] else ...[
                    Text(
                      "Tap to browse your PDF",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "PDF format only (Max 5MB)",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withAlpha(80),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.error.withAlpha(50)),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.alertTriangle, color: theme.colorScheme.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),

          if (hasResume && !_isPickingOrParsing)
            ElevatedButton(
              onPressed: widget.onUploadComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.nextStep,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  const Icon(LucideIcons.arrowRight, size: 18),
                ],
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: _isPickingOrParsing ? null : _pickResume,
              icon: const Icon(LucideIcons.fileSearch),
              label: Text(hasResume ? l10n.changeResumePdf : l10n.selectUploadResume),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurfaceVariant,
              ),
              child: const Text(
                'SKIP FOR NOW',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
