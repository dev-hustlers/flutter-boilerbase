import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';
import '../../main_screen/view/main_screen.dart';
import '../view_model/gemma_status_provider.dart';
import 'widgets/heighted_progress_bar.dart';
import 'pages/welcome_step.dart';
import 'pages/demographics_step.dart';
import 'pages/resume_upload_step.dart';
import 'pages/analysis_processing_step.dart';
import 'pages/analysis_dashboard_step.dart';

/// Onboarding Orchestrator Screen.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  static const int _totalSteps = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _advancePage() {
    if (_currentIndex < _totalSteps - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onFinish() async {
    final prefs = ref.read(preferencesServiceProvider);
    await prefs.setIsFirstTime(false);
    await prefs.setIsOnboardingCompleted(true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gemmaStatus = ref.watch(gemmaStatusProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Segmented Top Indicators
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: List.generate(_totalSteps, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: HeightedProgressBar(
                          isActive: index == _currentIndex,
                          isCompleted: index < _currentIndex,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Main un-swipable PageView
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Prevent swipe breaks
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  // Step 1: Welcome Page
                  WelcomeStep(
                    onSignInComplete: _advancePage,
                    isModelLoaded: gemmaStatus.isLoaded,
                    isDownloading: gemmaStatus.isDownloading,
                    downloadProgress: gemmaStatus.downloadProgress,
                  ),

                  // Step 2: Demographics Page
                  DemographicsStep(
                    onFocusChange: (_) {},
                    onValidationSuccess: _advancePage,
                  ),

                  // Step 3: Resume Upload Page
                  ResumeUploadStep(
                    onProgressLockChange: (_) {},
                    onUploadComplete: _advancePage,
                  ),

                  // Step 4: AI Analysis Processing Page
                  AnalysisProcessingStep(
                    onProcessingComplete: _advancePage,
                  ),

                  // Step 5: High-Impact Dashboard Page
                  AnalysisDashboardStep(
                    onFinish: _onFinish,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
