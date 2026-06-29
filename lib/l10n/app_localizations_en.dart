// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Catalyst';

  @override
  String get welcomeTitle => 'Welcome to Catalyst';

  @override
  String get welcomeSubtitle =>
      'AI powered career companion that helps you find, apply, and land your next job faster.';

  @override
  String get googleSignIn => 'Sign in with Google';

  @override
  String get localAiBrainActive => 'Local AI Brain Active';

  @override
  String get downloadingLocalAiBrain => 'Downloading local AI brain...';

  @override
  String downloadProgress(String progress) {
    return 'Download Progress: $progress%';
  }

  @override
  String get fetchingModelWeights =>
      'Fetching model weights for offline, on-device operations.';

  @override
  String get demographicsTitle => 'Tell us about yourself';

  @override
  String get demographicsSubtitle =>
      'This helps our local AI model understand your context and design-specific ATS enhancements.';

  @override
  String get fullName => 'Full Name';

  @override
  String get targetDiscipline => 'Target Discipline / Career Goal';

  @override
  String get educationProvider => 'Australian Education Provider';

  @override
  String get visaSubclassLabel => 'Australian Visa Subclass / Status';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get pleaseEnterDiscipline => 'Please enter your target discipline';

  @override
  String get pleaseEnterProvider => 'Please enter your education provider';

  @override
  String get nextStep => 'Next Step';

  @override
  String get uploadResume => 'Upload your Resume';

  @override
  String get privateLocalPdfParsing =>
      'We run completely private, local PDF parsing. Your document never leaves this device.';

  @override
  String get noPdfSelected => 'No PDF file selected.';

  @override
  String get resumeSuccessLoaded => 'Resume successfully loaded!';

  @override
  String get selectUploadResume => 'Select & Upload Resume PDF';

  @override
  String get changeResumePdf => 'Change Resume PDF';

  @override
  String get analyzingResume => 'Analyzing Resume...';

  @override
  String get gemmaRunningInference =>
      'Our local Gemma model is running inference on your resume text against ATS parameters.';

  @override
  String get extractingResumeText => 'Extracting resume text...';

  @override
  String get scanningDisciplineMatch =>
      'Scanning for target discipline match...';

  @override
  String get runningGemmaAts => 'Running Gemma ATS analysis...';

  @override
  String get generatingStarReport => 'Generating STAR improvement report...';

  @override
  String get inferenceCompleted => 'Inference Completed';

  @override
  String get resumeAnalysisDashboard => 'Resume Analysis Dashboard';

  @override
  String get basedOnGemma => 'Based on local Gemma 2B model feedback.';

  @override
  String get matchScore => 'Match Score';

  @override
  String get keywordVoids => 'Keywords Voids (Missing in Resume)';

  @override
  String get starCoachingMarkers => 'Actionable STAR Coaching Markers';

  @override
  String get completeOnboarding => 'Complete Onboarding & Enter App';

  @override
  String get navHome => 'Home';

  @override
  String get navJobs => 'Jobs';

  @override
  String get navResume => 'Resume';

  @override
  String get navPrep => 'Prep';

  @override
  String get navProfile => 'Profile';

  @override
  String get homePageShown => 'Home page shown here';

  @override
  String get jobsPageShown => 'Jobs page shown here';

  @override
  String get resumePageShown => 'Resume appear here';

  @override
  String get profilePageShown => 'Profile page shown here';

  @override
  String get prepAi => 'Prep AI';

  @override
  String get prepAiSetup => 'Prep AI Setup';

  @override
  String get downloadModelWeights => 'Download Model Weights';

  @override
  String get fetchGemmaWeightsDescription =>
      'To enable local, on-device AI responses and real-time audio synthesis, we need to fetch the Gemma weights. This runs entirely offline once downloaded.';

  @override
  String get downloadingModelWeights => 'Downloading model weights...';

  @override
  String get startDownload => 'Start Download';

  @override
  String get retryDownload => 'Retry Download';

  @override
  String errorDownloading(String error) {
    return 'Error downloading: $error';
  }

  @override
  String get gemma2b => 'Gemma 2B';

  @override
  String get deleteModelWeights => 'Delete Model Weights?';

  @override
  String get deleteModelWeightsDescription =>
      'This will delete the local Gemma model file from your device and reset the download screen.';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get nowSpeaking => 'Now Speaking...';

  @override
  String get audioEngineIdle => 'Audio Engine Idle';

  @override
  String get synthesizerIdle => 'Synthesizer is waiting for input sentences.';

  @override
  String queueBuffered(int count) {
    return 'Queue: $count sentence(s) buffered';
  }

  @override
  String get emergencyStop => 'Emergency Stop';

  @override
  String get haltedByUser => ' [HALTED BY USER]';

  @override
  String get llmPipelineStream => 'LLM Pipeline Stream';

  @override
  String get tryPresetPrompt => 'Try a preset prompt:';

  @override
  String get askGemmaAnything => 'Ask Gemma anything...';

  @override
  String get generatingResponse => 'Generating response...';

  @override
  String inferenceError(String error) {
    return 'Inference Error: $error';
  }

  @override
  String get presetQuantum => 'Explain quantum computing in simple terms.';

  @override
  String get presetRoutine => 'Give me a 3-step morning routine.';

  @override
  String get presetPipeline =>
      'Explain the Anti-Gravity Pipeline architecture.';

  @override
  String shareTargetLink(String path) {
    return 'Shared Link: $path';
  }

  @override
  String get dismiss => 'Dismiss';

  @override
  String get llmStreamSubtitle =>
      'Type a prompt or tap a preset below to see the natural language stream translate into synthesized audio.';

  @override
  String get splashTitle => 'Catalyst';

  @override
  String get splashSubtitle => 'Your Career Companion';
}
