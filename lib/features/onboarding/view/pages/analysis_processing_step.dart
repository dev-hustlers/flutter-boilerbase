import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:catalyst/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../view_model/onboarding_view_model.dart';

class AnalysisProcessingStep extends ConsumerStatefulWidget {
  final VoidCallback onProcessingComplete;

  const AnalysisProcessingStep({
    super.key,
    required this.onProcessingComplete,
  });

  @override
  ConsumerState<AnalysisProcessingStep> createState() => _AnalysisProcessingStepState();
}

class _AnalysisProcessingStepState extends ConsumerState<AnalysisProcessingStep> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingViewModelProvider.notifier).runResumeAnalysis(
        onComplete: widget.onProcessingComplete,
        onError: (err) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error during local Gemma inference: $err"),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final onboardingState = ref.watch(onboardingViewModelProvider);
    final uiProgress = onboardingState.processingProgress;
    final currentStage = onboardingState.processingStage;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.cpu,
            size: 80,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            l10n.analyzingResume,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.gemmaRunningInference,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 48),

          // Custom Circular Progress
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140.0,
                height: 140.0,
                child: CircularProgressIndicator(
                  value: uiProgress,
                  strokeWidth: 8,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                "${(uiProgress * 100).toStringAsFixed(0)}%",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
          Text(
            currentStage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Gemma 2B running in local secure sandbox",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
