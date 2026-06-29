/// State representing the onboarding flow fields and ATS processing progress.
class OnboardingState {
  final String fullName;
  final String targetDiscipline;
  final String educationProvider;
  final String visaSubclass;
  final String? resumePath;
  final String? resumeText;
  final String? aiAnalysisReport;
  final bool isProcessing;
  final double processingProgress;
  final String processingStage;

  OnboardingState({
    this.fullName = '',
    this.targetDiscipline = '',
    this.educationProvider = '',
    this.visaSubclass = 'PR/Citizen',
    this.resumePath,
    this.resumeText,
    this.aiAnalysisReport,
    this.isProcessing = false,
    this.processingProgress = 0.0,
    this.processingStage = '',
  });

  OnboardingState copyWith({
    String? fullName,
    String? targetDiscipline,
    String? educationProvider,
    String? visaSubclass,
    String? resumePath,
    String? resumeText,
    String? aiAnalysisReport,
    bool? isProcessing,
    double? processingProgress,
    String? processingStage,
  }) {
    return OnboardingState(
      fullName: fullName ?? this.fullName,
      targetDiscipline: targetDiscipline ?? this.targetDiscipline,
      educationProvider: educationProvider ?? this.educationProvider,
      visaSubclass: visaSubclass ?? this.visaSubclass,
      resumePath: resumePath ?? this.resumePath,
      resumeText: resumeText ?? this.resumeText,
      aiAnalysisReport: aiAnalysisReport ?? this.aiAnalysisReport,
      isProcessing: isProcessing ?? this.isProcessing,
      processingProgress: processingProgress ?? this.processingProgress,
      processingStage: processingStage ?? this.processingStage,
    );
  }
}
