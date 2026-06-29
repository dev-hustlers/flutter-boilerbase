import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Catalyst'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Catalyst'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI powered career companion that helps you find, apply, and land your next job faster.'**
  String get welcomeSubtitle;

  /// No description provided for @googleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get googleSignIn;

  /// No description provided for @localAiBrainActive.
  ///
  /// In en, this message translates to:
  /// **'Local AI Brain Active'**
  String get localAiBrainActive;

  /// No description provided for @downloadingLocalAiBrain.
  ///
  /// In en, this message translates to:
  /// **'Downloading local AI brain...'**
  String get downloadingLocalAiBrain;

  /// No description provided for @downloadProgress.
  ///
  /// In en, this message translates to:
  /// **'Download Progress: {progress}%'**
  String downloadProgress(String progress);

  /// No description provided for @fetchingModelWeights.
  ///
  /// In en, this message translates to:
  /// **'Fetching model weights for offline, on-device operations.'**
  String get fetchingModelWeights;

  /// No description provided for @demographicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get demographicsTitle;

  /// No description provided for @demographicsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps our local AI model understand your context and design-specific ATS enhancements.'**
  String get demographicsSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @targetDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Target Discipline / Career Goal'**
  String get targetDiscipline;

  /// No description provided for @educationProvider.
  ///
  /// In en, this message translates to:
  /// **'Australian Education Provider'**
  String get educationProvider;

  /// No description provided for @visaSubclassLabel.
  ///
  /// In en, this message translates to:
  /// **'Australian Visa Subclass / Status'**
  String get visaSubclassLabel;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Please enter your target discipline'**
  String get pleaseEnterDiscipline;

  /// No description provided for @pleaseEnterProvider.
  ///
  /// In en, this message translates to:
  /// **'Please enter your education provider'**
  String get pleaseEnterProvider;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @uploadResume.
  ///
  /// In en, this message translates to:
  /// **'Upload your Resume'**
  String get uploadResume;

  /// No description provided for @privateLocalPdfParsing.
  ///
  /// In en, this message translates to:
  /// **'We run completely private, local PDF parsing. Your document never leaves this device.'**
  String get privateLocalPdfParsing;

  /// No description provided for @noPdfSelected.
  ///
  /// In en, this message translates to:
  /// **'No PDF file selected.'**
  String get noPdfSelected;

  /// No description provided for @resumeSuccessLoaded.
  ///
  /// In en, this message translates to:
  /// **'Resume successfully loaded!'**
  String get resumeSuccessLoaded;

  /// No description provided for @selectUploadResume.
  ///
  /// In en, this message translates to:
  /// **'Select & Upload Resume PDF'**
  String get selectUploadResume;

  /// No description provided for @changeResumePdf.
  ///
  /// In en, this message translates to:
  /// **'Change Resume PDF'**
  String get changeResumePdf;

  /// No description provided for @analyzingResume.
  ///
  /// In en, this message translates to:
  /// **'Analyzing Resume...'**
  String get analyzingResume;

  /// No description provided for @gemmaRunningInference.
  ///
  /// In en, this message translates to:
  /// **'Our local Gemma model is running inference on your resume text against ATS parameters.'**
  String get gemmaRunningInference;

  /// No description provided for @extractingResumeText.
  ///
  /// In en, this message translates to:
  /// **'Extracting resume text...'**
  String get extractingResumeText;

  /// No description provided for @scanningDisciplineMatch.
  ///
  /// In en, this message translates to:
  /// **'Scanning for target discipline match...'**
  String get scanningDisciplineMatch;

  /// No description provided for @runningGemmaAts.
  ///
  /// In en, this message translates to:
  /// **'Running Gemma ATS analysis...'**
  String get runningGemmaAts;

  /// No description provided for @generatingStarReport.
  ///
  /// In en, this message translates to:
  /// **'Generating STAR improvement report...'**
  String get generatingStarReport;

  /// No description provided for @inferenceCompleted.
  ///
  /// In en, this message translates to:
  /// **'Inference Completed'**
  String get inferenceCompleted;

  /// No description provided for @resumeAnalysisDashboard.
  ///
  /// In en, this message translates to:
  /// **'Resume Analysis Dashboard'**
  String get resumeAnalysisDashboard;

  /// No description provided for @basedOnGemma.
  ///
  /// In en, this message translates to:
  /// **'Based on local Gemma 2B model feedback.'**
  String get basedOnGemma;

  /// No description provided for @matchScore.
  ///
  /// In en, this message translates to:
  /// **'Match Score'**
  String get matchScore;

  /// No description provided for @keywordVoids.
  ///
  /// In en, this message translates to:
  /// **'Keywords Voids (Missing in Resume)'**
  String get keywordVoids;

  /// No description provided for @starCoachingMarkers.
  ///
  /// In en, this message translates to:
  /// **'Actionable STAR Coaching Markers'**
  String get starCoachingMarkers;

  /// No description provided for @completeOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Complete Onboarding & Enter App'**
  String get completeOnboarding;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navJobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get navJobs;

  /// No description provided for @navResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get navResume;

  /// No description provided for @navPrep.
  ///
  /// In en, this message translates to:
  /// **'Prep'**
  String get navPrep;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @homePageShown.
  ///
  /// In en, this message translates to:
  /// **'Home page shown here'**
  String get homePageShown;

  /// No description provided for @jobsPageShown.
  ///
  /// In en, this message translates to:
  /// **'Jobs page shown here'**
  String get jobsPageShown;

  /// No description provided for @resumePageShown.
  ///
  /// In en, this message translates to:
  /// **'Resume appear here'**
  String get resumePageShown;

  /// No description provided for @profilePageShown.
  ///
  /// In en, this message translates to:
  /// **'Profile page shown here'**
  String get profilePageShown;

  /// No description provided for @prepAi.
  ///
  /// In en, this message translates to:
  /// **'Prep AI'**
  String get prepAi;

  /// No description provided for @prepAiSetup.
  ///
  /// In en, this message translates to:
  /// **'Prep AI Setup'**
  String get prepAiSetup;

  /// No description provided for @downloadModelWeights.
  ///
  /// In en, this message translates to:
  /// **'Download Model Weights'**
  String get downloadModelWeights;

  /// No description provided for @fetchGemmaWeightsDescription.
  ///
  /// In en, this message translates to:
  /// **'To enable local, on-device AI responses and real-time audio synthesis, we need to fetch the Gemma weights. This runs entirely offline once downloaded.'**
  String get fetchGemmaWeightsDescription;

  /// No description provided for @downloadingModelWeights.
  ///
  /// In en, this message translates to:
  /// **'Downloading model weights...'**
  String get downloadingModelWeights;

  /// No description provided for @startDownload.
  ///
  /// In en, this message translates to:
  /// **'Start Download'**
  String get startDownload;

  /// No description provided for @retryDownload.
  ///
  /// In en, this message translates to:
  /// **'Retry Download'**
  String get retryDownload;

  /// No description provided for @errorDownloading.
  ///
  /// In en, this message translates to:
  /// **'Error downloading: {error}'**
  String errorDownloading(String error);

  /// No description provided for @gemma2b.
  ///
  /// In en, this message translates to:
  /// **'Gemma 2B'**
  String get gemma2b;

  /// No description provided for @deleteModelWeights.
  ///
  /// In en, this message translates to:
  /// **'Delete Model Weights?'**
  String get deleteModelWeights;

  /// No description provided for @deleteModelWeightsDescription.
  ///
  /// In en, this message translates to:
  /// **'This will delete the local Gemma model file from your device and reset the download screen.'**
  String get deleteModelWeightsDescription;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @nowSpeaking.
  ///
  /// In en, this message translates to:
  /// **'Now Speaking...'**
  String get nowSpeaking;

  /// No description provided for @audioEngineIdle.
  ///
  /// In en, this message translates to:
  /// **'Audio Engine Idle'**
  String get audioEngineIdle;

  /// No description provided for @synthesizerIdle.
  ///
  /// In en, this message translates to:
  /// **'Synthesizer is waiting for input sentences.'**
  String get synthesizerIdle;

  /// No description provided for @queueBuffered.
  ///
  /// In en, this message translates to:
  /// **'Queue: {count} sentence(s) buffered'**
  String queueBuffered(int count);

  /// No description provided for @emergencyStop.
  ///
  /// In en, this message translates to:
  /// **'Emergency Stop'**
  String get emergencyStop;

  /// No description provided for @haltedByUser.
  ///
  /// In en, this message translates to:
  /// **' [HALTED BY USER]'**
  String get haltedByUser;

  /// No description provided for @llmPipelineStream.
  ///
  /// In en, this message translates to:
  /// **'LLM Pipeline Stream'**
  String get llmPipelineStream;

  /// No description provided for @tryPresetPrompt.
  ///
  /// In en, this message translates to:
  /// **'Try a preset prompt:'**
  String get tryPresetPrompt;

  /// No description provided for @askGemmaAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask Gemma anything...'**
  String get askGemmaAnything;

  /// No description provided for @generatingResponse.
  ///
  /// In en, this message translates to:
  /// **'Generating response...'**
  String get generatingResponse;

  /// No description provided for @inferenceError.
  ///
  /// In en, this message translates to:
  /// **'Inference Error: {error}'**
  String inferenceError(String error);

  /// No description provided for @presetQuantum.
  ///
  /// In en, this message translates to:
  /// **'Explain quantum computing in simple terms.'**
  String get presetQuantum;

  /// No description provided for @presetRoutine.
  ///
  /// In en, this message translates to:
  /// **'Give me a 3-step morning routine.'**
  String get presetRoutine;

  /// No description provided for @presetPipeline.
  ///
  /// In en, this message translates to:
  /// **'Explain the Anti-Gravity Pipeline architecture.'**
  String get presetPipeline;

  /// No description provided for @shareTargetLink.
  ///
  /// In en, this message translates to:
  /// **'Shared Link: {path}'**
  String shareTargetLink(String path);

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @llmStreamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Type a prompt or tap a preset below to see the natural language stream translate into synthesized audio.'**
  String get llmStreamSubtitle;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalyst'**
  String get splashTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your Career Companion'**
  String get splashSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
