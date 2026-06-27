import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/onboarding_state.dart';
import '../../services/preferences_service.dart';
import '../../main.dart'; // To access GemmaInferenceService
import 'steps/welcome_step.dart';
import 'steps/demographics_step.dart';
import 'steps/resume_upload_step.dart';
import 'steps/analysis_processing_step.dart';
import 'steps/analysis_dashboard_step.dart';

class OnboardingScreen extends StatefulWidget {
  final PreferencesService preferencesService;
  final VoidCallback onOnboardingFinished;

  const OnboardingScreen({
    super.key,
    required this.preferencesService,
    required this.onOnboardingFinished,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final OnboardingState _state = OnboardingState();
  final GemmaInferenceService _gemma = GemmaInferenceService();

  int _currentIndex = 0;
  static const int _totalSteps = 5;

  // Custom progress bar animation controller (WhatsApp status style)
  late AnimationController _progressController;
  
  // Timer locks
  bool _isKeyboardFocused = false;
  bool _isCustomLocked = false; // For PDF picking or Gemma processing
  
  // Model download progress tracking
  bool _isModelLoaded = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  StreamSubscription? _downloadSubscription;

  @override
  void initState() {
    super.initState();
    
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // 8 seconds per slide by default
    );

    _progressController.addListener(() {
      if (_progressController.isCompleted) {
        _advancePage();
      }
    });

    // Start checking and warming up the Gemma model immediately
    _warmUpGemma();

    // Start the story progress bar
    _startStoryTimer();
  }

  @override
  void dispose() {
    _downloadSubscription?.cancel();
    _progressController.dispose();
    _pageController.dispose();
    _state.dispose();
    super.dispose();
  }

  // WARM UP GEMMA SYSTEM ACTION
  Future<void> _warmUpGemma() async {
    final exists = await _gemma.checkModelExists();
    if (exists) {
      if (mounted) {
        setState(() {
          _isModelLoaded = true;
          _isDownloading = false;
        });
      }
    } else {
      // Trigger background model download immediately
      if (mounted) {
        setState(() {
          _isDownloading = true;
        });
      }
      _downloadSubscription = _gemma.downloadModel().listen(
        (progress) {
          if (mounted) {
            setState(() {
              _downloadProgress = progress;
            });
          }
        },
        onError: (err) {
          debugPrint("Onboarding background model download error: $err");
          if (mounted) {
            setState(() {
              _isDownloading = false;
            });
          }
        },
        onDone: () {
          if (mounted) {
            setState(() {
              _isModelLoaded = true;
              _isDownloading = false;
            });
          }
        },
        cancelOnError: true,
      );
    }
  }

  void _startStoryTimer() {
    if (_isKeyboardFocused || _isCustomLocked) {
      _progressController.stop();
    } else {
      _progressController.forward();
    }
  }

  void _updateLocks({bool? keyboard, bool? custom}) {
    if (keyboard != null) _isKeyboardFocused = keyboard;
    if (custom != null) _isCustomLocked = custom;

    if (_isKeyboardFocused || _isCustomLocked) {
      _progressController.stop();
    } else {
      _progressController.forward();
    }
  }

  void _advancePage() {
    if (_currentIndex < _totalSteps - 1) {
      // Check manual validation for demographics & resume steps before auto-advancing
      if (_currentIndex == 1 && _state.fullName.isEmpty) {
        // Validation failed, reset timer but stay here
        _progressController.reset();
        _progressController.forward();
        return;
      }
      if (_currentIndex == 2 && _state.resumePath == null) {
        _progressController.reset();
        _progressController.forward();
        return;
      }

      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressController.reset();
      _startStoryTimer();
    }
  }



  void _onFinish() async {
    // Save onboarding completion state to SharedPreferences
    await widget.preferencesService.setIsFirstTime(false);
    await widget.preferencesService.setIsOnboardingCompleted(true);
    widget.onOnboardingFinished();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Disable auto-advance in Step 4 & 5 to avoid cutting off user reading
    if (_currentIndex == 3 || _currentIndex == 4) {
      _isCustomLocked = true;
      _progressController.stop();
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // WhatsApp Status Segmented Top Indicators
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
                          animation: _progressController,
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
                    onSignInComplete: () {
                      _advancePage();
                    },
                    isModelLoaded: _isModelLoaded,
                    isDownloading: _isDownloading,
                    downloadProgress: _downloadProgress,
                  ),

                  // Step 2: Demographics Page
                  DemographicsStep(
                    state: _state,
                    onFocusChange: (isFocused) {
                      _updateLocks(keyboard: isFocused);
                    },
                    onValidationSuccess: () {
                      _updateLocks(keyboard: false);
                      _advancePage();
                    },
                  ),

                  // Step 3: Resume Upload Page
                  ResumeUploadStep(
                    state: _state,
                    onProgressLockChange: (isLocked) {
                      _updateLocks(custom: isLocked);
                    },
                    onUploadComplete: () {
                      _updateLocks(custom: false);
                      _advancePage();
                    },
                  ),

                  // Step 4: AI Analysis Processing Page
                  AnimatedBuilder(
                    animation: _state,
                    builder: (context, child) {
                      return AnalysisProcessingStep(
                        state: _state,
                        onProcessingComplete: () {
                          _advancePage();
                        },
                      );
                    },
                  ),

                  // Step 5: High-Impact Dashboard Page
                  AnimatedBuilder(
                    animation: _state,
                    builder: (context, child) {
                      return AnalysisDashboardStep(
                        state: _state,
                        onFinish: _onFinish,
                      );
                    },
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

// Custom segment progress bar drawer
class HeightedProgressBar extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;
  final Animation<double> animation;

  const HeightedProgressBar({
    super.key,
    required this.isActive,
    required this.isCompleted,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    double value = 0.0;
    if (isCompleted) {
      value = 1.0;
    } else if (isActive) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return LinearProgressIndicator(
            value: animation.value,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: theme.colorScheme.primary,
            minHeight: 4,
          );
        },
      );
    }

    return LinearProgressIndicator(
      value: value,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      color: theme.colorScheme.primary,
      minHeight: 4,
    );
  }
}
