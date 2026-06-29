import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/onboarding_state.dart';
import '../../../core/providers/service_providers.dart';

/// ViewModel managing the onboarding flow form details and analysis state.
class OnboardingNotifier extends AutoDisposeNotifier<OnboardingState> {
  StreamSubscription? _gemmaSubscription;
  Timer? _progressTimer;

  @override
  OnboardingState build() {
    ref.onDispose(() {
      _progressTimer?.cancel();
      _gemmaSubscription?.cancel();
    });
    return OnboardingState();
  }

  void setFullName(String value) {
    state = state.copyWith(fullName: value);
  }

  void setTargetDiscipline(String value) {
    state = state.copyWith(targetDiscipline: value);
  }

  void setEducationProvider(String value) {
    state = state.copyWith(educationProvider: value);
  }

  void setVisaSubclass(String value) {
    state = state.copyWith(visaSubclass: value);
  }

  void setResume(String path, String text) {
    state = state.copyWith(resumePath: path, resumeText: text);
  }

  void setAiAnalysisReport(String? value) {
    state = state.copyWith(aiAnalysisReport: value);
  }

  void setProcessing(bool value) {
    state = state.copyWith(isProcessing: value);
  }

  void updateProcessing(double progress, String stage) {
    state = state.copyWith(processingProgress: progress, processingStage: stage);
  }

  void reset() {
    state = OnboardingState();
  }

  /// Run local Gemma analysis in background and animate progress indicators.
  Future<void> runResumeAnalysis({
    required Function() onComplete,
    required Function(String error) onError,
  }) async {
    state = state.copyWith(
      isProcessing: true,
      processingProgress: 0.0,
      processingStage: "Preparing analysis engine...",
      aiAnalysisReport: null,
    );

    double uiProgress = 0.0;
    String currentStage = "Preparing analysis engine...";

    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (uiProgress < 0.25) {
        uiProgress += 0.01;
        currentStage = "Reading raw resume text characters...";
      } else if (uiProgress < 0.55) {
        uiProgress += 0.008;
        currentStage = "Targeting ${state.targetDiscipline} guidelines...";
      } else if (uiProgress < 0.85) {
        uiProgress += 0.005;
        currentStage = "Synthesizing Gemma 2B career recommendations...";
      }
      state = state.copyWith(processingProgress: uiProgress, processingStage: currentStage);
    });

    try {
      final pipeline = ref.read(antiGravityPipelineProvider);
      await pipeline.initialize();

      final String systemPrompt = """
You are an expert in Resume Screening and ATS Optimization.

Analyze the following target job designation and resume, and provide:

1. **Match Score** (0–100): Rate how well the resume aligns with the target designation.

2. **Missing Keywords/Skills**: List critical skills, tools, technologies, or terms required for the designation but missing in the resume.

3. **Role Alignment**: Assess how well the resume reflects the responsibilities and qualifications required for the designation.

4. **Suggestions for Improvement**: Clearly list actionable improvements (e.g., add specific tools, mention frameworks, quantify impact, improve role relevance).

Avoid all general closing statements like "This will improve your chances" or "By doing this, the candidate will be more successful." Stick strictly to the analysis.

---
**Target Designation**:
${state.targetDiscipline}

---
**Resume**:
${state.resumeText}
""";

      final reportBuffer = StringBuffer();

      await _gemmaSubscription?.cancel();
      _gemmaSubscription = pipeline.gemma.streamResponse(systemPrompt).listen(
        (token) {
          reportBuffer.write(token);
          state = state.copyWith(aiAnalysisReport: reportBuffer.toString());
        },
        onDone: () {
          _progressTimer?.cancel();
          state = state.copyWith(
            processingProgress: 1.0,
            processingStage: "Analysis complete!",
          );
          Future.delayed(const Duration(milliseconds: 800), () {
            onComplete();
          });
        },
        onError: (err) {
          _progressTimer?.cancel();
          onError(err.toString());
        },
      );

    } catch (e) {
      _progressTimer?.cancel();
      onError(e.toString());
    }
  }
}

final onboardingViewModelProvider = AutoDisposeNotifierProvider<OnboardingNotifier, OnboardingState>(() {
  return OnboardingNotifier();
});
