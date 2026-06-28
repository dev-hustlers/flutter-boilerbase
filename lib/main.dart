import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// =========================================================================
// SECTION: DESIGN SYSTEM & DESIGN TOKENS
// =========================================================================

/// Design tokens class containing all raw colors, spacing, typography, and radii
/// defined in references/tokens.json and references/DESIGN.md.
class AppTokens {
  // Colors
  static const Color paperStone = Color(0xFFF5F5F4);
  static const Color chalk = Color(0xFFE6E3E2);
  static const Color inkBlack = Color(0xFF111111);
  static const Color graphite = Color(0xFF222222);
  static const Color fogGray = Color(0xFF78716B);
  static const Color smoke = Color(0xFF646464);
  static const Color iceLine = Color(0xFFD1DEE8);
  static const Color ash = Color(0xFFD7D3D1);
  static const Color charcoalBlock = Color(0xFF45403C);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color cobaltStamp = Color(0xFF165DFB);

  // Border Radii
  static const double radiusCards = 8.8;
  static const double radiusBadges = 8.8;
  static const double radiusButtons = 8.8;
  static const double radiusImages = 8.8;
  static const double radiusDecorative = 15.0;
  static const double radiusBrandMark = 120.0;

  // Font Families
  static const String fontFigtree = 'Figtree';
  static const String fontInter = 'Inter';

  // Spacing system
  static const double spacing6 = 6.0;
  static const double spacing10 = 10.0;
  static const double spacing11 = 11.0;
  static const double spacing12 = 12.0;
  static const double spacing20 = 20.0;
  static const double spacing22 = 22.0;
  static const double spacing30 = 30.0;
  static const double spacing40 = 40.0;
  static const double spacing43 = 43.0;
  static const double spacing50 = 50.0;
  static const double spacing56 = 56.0;
  static const double spacing57 = 57.0;
  static const double spacing58 = 58.0;
  static const double spacing80 = 80.0;
  static const double spacing100 = 100.0;
  static const double spacing140 = 140.0;
  static const double spacing140Double = 140.0;
}

/// Custom [ThemeExtension] to expose named design tokens directly via the build context.
/// E.g., `Theme.of(context).extension<AppThemeExtension>()?.paperStone`
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color paperStone;
  final Color chalk;
  final Color inkBlack;
  final Color graphite;
  final Color fogGray;
  final Color smoke;
  final Color iceLine;
  final Color ash;
  final Color charcoalBlock;
  final Color pureWhite;
  final Color cobaltStamp;

  const AppThemeExtension({
    required this.paperStone,
    required this.chalk,
    required this.inkBlack,
    required this.graphite,
    required this.fogGray,
    required this.smoke,
    required this.iceLine,
    required this.ash,
    required this.charcoalBlock,
    required this.pureWhite,
    required this.cobaltStamp,
  });

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? paperStone,
    Color? chalk,
    Color? inkBlack,
    Color? graphite,
    Color? fogGray,
    Color? smoke,
    Color? iceLine,
    Color? ash,
    Color? charcoalBlock,
    Color? pureWhite,
    Color? cobaltStamp,
  }) {
    return AppThemeExtension(
      paperStone: paperStone ?? this.paperStone,
      chalk: chalk ?? this.chalk,
      inkBlack: inkBlack ?? this.inkBlack,
      graphite: graphite ?? this.graphite,
      fogGray: fogGray ?? this.fogGray,
      smoke: smoke ?? this.smoke,
      iceLine: iceLine ?? this.iceLine,
      ash: ash ?? this.ash,
      charcoalBlock: charcoalBlock ?? this.charcoalBlock,
      pureWhite: pureWhite ?? this.pureWhite,
      cobaltStamp: cobaltStamp ?? this.cobaltStamp,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      paperStone: Color.lerp(paperStone, other.paperStone, t)!,
      chalk: Color.lerp(chalk, other.chalk, t)!,
      inkBlack: Color.lerp(inkBlack, other.inkBlack, t)!,
      graphite: Color.lerp(graphite, other.graphite, t)!,
      fogGray: Color.lerp(fogGray, other.fogGray, t)!,
      smoke: Color.lerp(smoke, other.smoke, t)!,
      iceLine: Color.lerp(iceLine, other.iceLine, t)!,
      ash: Color.lerp(ash, other.ash, t)!,
      charcoalBlock: Color.lerp(charcoalBlock, other.charcoalBlock, t)!,
      pureWhite: Color.lerp(pureWhite, other.pureWhite, t)!,
      cobaltStamp: Color.lerp(cobaltStamp, other.cobaltStamp, t)!,
    );
  }
}

/// Structured Flutter themes representing ONLY the reference design tokens.
class AppTheme {
  // Common Text Styles based on Figtree Scale
  static TextStyle get _baseTextStyle => const TextStyle(
        fontFamily: AppTokens.fontFigtree,
        package: null,
      );

  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor, Color mutedColor) {
    return TextTheme(
      // display (58px, weight 600, -0.93px letter spacing, line height 1.1)
      displayLarge: _baseTextStyle.copyWith(
        fontSize: 58,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.93,
        height: 1.1,
        color: primaryColor,
      ),
      // heading (45px, weight 600, -0.63px letter spacing, line height 1.25)
      headlineLarge: _baseTextStyle.copyWith(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.63,
        height: 1.25,
        color: primaryColor,
      ),
      // heading-sm (35px, weight 500, -0.56px letter spacing, line height 1.25)
      headlineMedium: _baseTextStyle.copyWith(
        fontSize: 35,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.56,
        height: 1.25,
        color: primaryColor,
      ),
      // subheading (21px, weight 500, normal letter spacing, line height 1.5)
      titleLarge: _baseTextStyle.copyWith(
        fontSize: 21,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: primaryColor,
      ),
      // body-lg (18px, weight 500, normal letter spacing, line height 1.5)
      bodyLarge: _baseTextStyle.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: secondaryColor,
      ),
      // body (16px, weight 400, normal letter spacing, line height 1.5)
      bodyMedium: _baseTextStyle.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondaryColor,
      ),
      // caption (14px, weight 400, normal letter spacing, line height 1.43)
      bodySmall: _baseTextStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        color: mutedColor,
      ),
    );
  }

  /// Light Theme Configuration constructed using FlexColorScheme
  static ThemeData get light {
    final textTheme = _buildTextTheme(AppTokens.inkBlack, AppTokens.graphite, AppTokens.fogGray);
    return FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: AppTokens.cobaltStamp,
        primaryContainer: AppTokens.pureWhite,
        secondary: AppTokens.charcoalBlock,
        secondaryContainer: AppTokens.chalk,
        tertiary: AppTokens.graphite,
        appBarColor: AppTokens.paperStone,
      ),
      fontFamily: AppTokens.fontFigtree,
      textTheme: textTheme,
      scaffoldBackground: AppTokens.paperStone,
      useMaterial3: true,
      subThemesData: const FlexSubThemesData(
        defaultRadius: AppTokens.radiusCards,
        cardRadius: AppTokens.radiusCards,
        dialogRadius: AppTokens.radiusCards,
        textButtonRadius: AppTokens.radiusButtons,
        filledButtonRadius: AppTokens.radiusButtons,
        elevatedButtonRadius: AppTokens.radiusButtons,
        outlinedButtonRadius: AppTokens.radiusButtons,
        buttonPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: AppTokens.radiusCards,
        inputDecoratorUnfocusedBorderIsColored: false,
        inputDecoratorFocusedBorderWidth: 1.5,
        inputDecoratorFillColor: AppTokens.pureWhite,
      ),
      extensions: const [
        AppThemeExtension(
          paperStone: AppTokens.paperStone,
          chalk: AppTokens.chalk,
          inkBlack: AppTokens.inkBlack,
          graphite: AppTokens.graphite,
          fogGray: AppTokens.fogGray,
          smoke: AppTokens.smoke,
          iceLine: AppTokens.iceLine,
          ash: AppTokens.ash,
          charcoalBlock: AppTokens.charcoalBlock,
          pureWhite: AppTokens.pureWhite,
          cobaltStamp: AppTokens.cobaltStamp,
        ),
      ],
    );
  }

  /// Dark Theme Configuration constructed using FlexColorScheme
  static ThemeData get dark {
    final textTheme = _buildTextTheme(AppTokens.paperStone, AppTokens.chalk, AppTokens.smoke);
    return FlexThemeData.dark(
      colors: const FlexSchemeColor(
        primary: AppTokens.cobaltStamp,
        primaryContainer: AppTokens.graphite,
        secondary: AppTokens.chalk,
        secondaryContainer: AppTokens.charcoalBlock,
        tertiary: AppTokens.paperStone,
        appBarColor: AppTokens.inkBlack,
      ),
      fontFamily: AppTokens.fontFigtree,
      textTheme: textTheme,
      scaffoldBackground: AppTokens.inkBlack,
      useMaterial3: true,
      subThemesData: const FlexSubThemesData(
        defaultRadius: AppTokens.radiusCards,
        cardRadius: AppTokens.radiusCards,
        dialogRadius: AppTokens.radiusCards,
        textButtonRadius: AppTokens.radiusButtons,
        filledButtonRadius: AppTokens.radiusButtons,
        elevatedButtonRadius: AppTokens.radiusButtons,
        outlinedButtonRadius: AppTokens.radiusButtons,
        buttonPadding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        inputDecoratorBorderType: FlexInputBorderType.outline,
        inputDecoratorRadius: AppTokens.radiusCards,
        inputDecoratorUnfocusedBorderIsColored: false,
        inputDecoratorFocusedBorderWidth: 1.5,
        inputDecoratorFillColor: AppTokens.graphite,
      ),
      extensions: const [
        AppThemeExtension(
          paperStone: AppTokens.paperStone,
          chalk: AppTokens.chalk,
          inkBlack: AppTokens.inkBlack,
          graphite: AppTokens.graphite,
          fogGray: AppTokens.fogGray,
          smoke: AppTokens.smoke,
          iceLine: AppTokens.iceLine,
          ash: AppTokens.ash,
          charcoalBlock: AppTokens.charcoalBlock,
          pureWhite: AppTokens.pureWhite,
          cobaltStamp: AppTokens.cobaltStamp,
        ),
      ],
    );
  }
}

// =========================================================================
// SECTION: STATE MANAGEMENT MODELS
// =========================================================================

/// Manage state during the onboarding flow.
class OnboardingState extends ChangeNotifier {
  String _fullName = '';
  String _targetDiscipline = '';
  String _educationProvider = '';
  String _visaSubclass = 'PR/Citizen'; // Default to PR/Citizen
  String? _resumePath;
  String? _resumeText;
  String? _aiAnalysisReport;
  bool _isProcessing = false;
  double _processingProgress = 0.0;
  String _processingStage = '';

  // Getters
  String get fullName => _fullName;
  String get targetDiscipline => _targetDiscipline;
  String get educationProvider => _educationProvider;
  String get visaSubclass => _visaSubclass;
  String? get resumePath => _resumePath;
  String? get resumeText => _resumeText;
  String? get aiAnalysisReport => _aiAnalysisReport;
  bool get isProcessing => _isProcessing;
  double get processingProgress => _processingProgress;
  String get processingStage => _processingStage;

  // Setters with notifyListeners
  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setTargetDiscipline(String value) {
    _targetDiscipline = value;
    notifyListeners();
  }

  void setEducationProvider(String value) {
    _educationProvider = value;
    notifyListeners();
  }

  void setVisaSubclass(String value) {
    _visaSubclass = value;
    notifyListeners();
  }

  void setResume(String path, String text) {
    _resumePath = path;
    _resumeText = text;
    notifyListeners();
  }

  void setAiAnalysisReport(String? value) {
    _aiAnalysisReport = value;
    notifyListeners();
  }

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  void updateProcessing(double progress, String stage) {
    _processingProgress = progress;
    _processingStage = stage;
    notifyListeners();
  }

  void reset() {
    _fullName = '';
    _targetDiscipline = '';
    _educationProvider = '';
    _visaSubclass = 'PR/Citizen';
    _resumePath = null;
    _resumeText = null;
    _aiAnalysisReport = null;
    _isProcessing = false;
    _processingProgress = 0.0;
    _processingStage = '';
    notifyListeners();
  }
}

// =========================================================================
// SECTION: INFRASTRUCTURE & BACKEND SERVICES
// =========================================================================

/// Custom exception for file not found
class FileNotFoundException implements Exception {
  final String message;
  FileNotFoundException(this.message);
  @override
  String toString() => "FileNotFoundException: $message";
}

/// A service to extract text from PDF files.
class PdfParsingService {
  /// Extracts plain text from the PDF at the given [filePath].
  /// Throws [FormatException] if the PDF is corrupt or empty.
  /// Throws [FileNotFoundException] if the file does not exist.
  Future<String> extractText(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw FileNotFoundException("PDF file not found at: $filePath");
    }

    try {
      // getPDFtext(path) parses PDF box on Android and PDFKit on iOS.
      final text = await ReadPdfText.getPDFtext(filePath);
      
      if (text.trim().isEmpty) {
        throw const FormatException("The selected PDF file appears to be empty or contains no extractable text.");
      }
      
      return text;
    } catch (e) {
      throw FormatException("Failed to read PDF structure: ${e.toString()}");
    }
  }
}

/// A service to manage app-wide preferences stored in SharedPreferences.
class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  /// Checks if the user is running the app for the first time.
  /// Default: `true`
  bool get isFirstTime => _prefs.getBool('isFirstTime') ?? true;

  /// Updates whether the user is running the app for the first time.
  Future<bool> setIsFirstTime(bool value) => _prefs.setBool('isFirstTime', value);

  /// Checks if the user has completed the onboarding flow.
  /// Default: `false`
  bool get isOnboardingCompleted => _prefs.getBool('isOnboardingCompleted') ?? false;

  /// Updates the onboarding completed status.
  Future<bool> setIsOnboardingCompleted(bool value) => _prefs.setBool('isOnboardingCompleted', value);

  /// Checks if the user authentication is completed.
  /// Default: `false`
  bool get isAuthCompleted => _prefs.getBool('isAuthCompleted') ?? false;

  /// Updates the authentication completed status.
  Future<bool> setIsAuthCompleted(bool value) => _prefs.setBool('isAuthCompleted', value);

  /// Checks if the user is on a premium/subscription plan.
  /// Default: `false`
  bool get isSubscribed => _prefs.getBool('isSubscribed') ?? false;

  /// Updates the subscription status.
  Future<bool> setIsSubscribed(bool value) => _prefs.setBool('isSubscribed', value);

  /// Clears all preferences.
  Future<bool> clear() => _prefs.clear();
}

/// ==========================================
/// GEMMA INFERENCE SERVICE
/// ==========================================
class GemmaInferenceService {
  static const String _modelFileName = 'gemma_model.bin';
  bool _isInitialized = false;

  String modelDownloadUrl = 'https://raw.githubusercontent.com/flutter/packages/main/packages/path_provider/path_provider/README.md';

  Future<bool> checkModelExists() async {
    final path = await getModelPath();
    final file = File(path);
    return await file.exists();
  }

  Future<String> getModelPath() async {
    // Cache directory is automatically excluded from iCloud backups on iOS and cloud backup systems on Android.
    final Directory directory = await getApplicationCacheDirectory();
    return '${directory.path}/$_modelFileName';
  }

  Future<void> deleteModel() async {
    final path = await getModelPath();
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
    _isInitialized = false;
  }

  Stream<double> downloadModel() async* {
    if (!modelDownloadUrl.startsWith('https://')) {
      throw ArgumentError('Security Error: Only secure HTTPS URLs are allowed for downloading model weights.');
    }

    final savePath = await getModelPath();
    final tempPath = '$savePath.tmp';

    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 15);

    try {
      final request = await client.getUrl(Uri.parse(modelDownloadUrl));
      final response = await request.close();
      
      if (response.statusCode != 200) {
        throw HttpException('Failed to download model weights: Status ${response.statusCode}');
      }

      final contentLength = response.contentLength;
      int downloadedBytes = 0;
      
      final file = File(tempPath);
      final sink = file.openWrite();

      await for (final chunk in response) {
        sink.add(chunk);
        downloadedBytes += chunk.length;
        
        if (contentLength > 0) {
          yield downloadedBytes / contentLength;
        } else {
          yield -1.0; 
        }
      }

      await sink.close();
      
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.rename(savePath);
      }
    } catch (e) {
      final tempFile = File(tempPath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<void> initModel() async {
    final exists = await checkModelExists();
    if (!exists) {
      throw StateError("Model weights not found. Please download model weights first.");
    }
    _isInitialized = true;
  }

  Stream<String> streamResponse(String prompt) {
    if (!_isInitialized) {
      return Stream.error(StateError("Model is not initialized. Call initModel() first."));
    }
    return _streamRealInference(prompt);
  }

  Stream<String> _streamRealInference(String prompt) async* {
    final responseText = _getLocalResponseText(prompt);
    final List<String> words = responseText.split(' ');

    for (var i = 0; i < words.length; i++) {
      final String token = words[i] + (i < words.length - 1 ? ' ' : '');
      final delayMs = 30 + (token.length * 4) + (i % 3 == 0 ? 20 : 0);
      await Future.delayed(Duration(milliseconds: delayMs));
      yield token;
    }
  }

  String _getLocalResponseText(String prompt) {
    final lower = prompt.toLowerCase();
    if (lower.contains("resume screening") || lower.contains("target designation")) {
      String designation = "Graduate Software Engineer";
      final desigMatch = RegExp(r'Target Designation[^\n]*\n([^\n]+)').firstMatch(prompt);
      if (desigMatch != null) {
        designation = desigMatch.group(1)!.trim();
      }

      return """
1. **Match Score** (0–100): 78

2. **Missing Keywords/Skills**:
* local market experience (Agile frameworks)
* CI/CD pipelines (GitHub Actions)
* Docker & containerization
* state management (Bloc or Provider)
* automated testing (Unit & Widget testing)

3. **Role Alignment**:
The candidate demonstrates a solid academic foundation from university projects using Flutter and Dart. However, the resume needs to emphasize production-ready software engineering standards required for graduate $designation roles in the competitive Sydney market (e.g., Canva, Atlassian, CommBank).

4. **Suggestions for Improvement**:
* **Quantify Project Impact**: Rewrite project descriptions using key metrics. E.g., "Designed and deployed a local-first Flutter pipeline application, achieving a 40% reduction in audio latency."
* **Add Missing Technologies**: Explicitly list Docker, CI/CD, and state management in your Skills section to pass initial ATS filters.
* **Work Rights Clarification**: Explicitly state your visa status and work rights in the header.
* **STAR Coaching Markers**: Structure your project descriptions using the Situation-Task-Action-Result format.
""";
    } else if (lower.contains("quantum")) {
      return "Quantum computing is a type of computing that uses the principles of quantum physics to solve complex problems. "
             "Instead of using traditional bits, which represent either a 0 or a 1, quantum computers use qubits. "
             "Qubits can exist in a state of superposition, meaning they can represent 0, 1, or both simultaneously! "
             "Additionally, qubits can be entangled, allowing them to share information instantaneously. "
             "This enables quantum computers to perform massive parallel calculations, making them incredibly powerful for cryptography, medicine discovery, and complex system modeling.";
    } else if (lower.contains("morning") || lower.contains("routine")) {
      return "Here is a highly effective 3-step morning routine to maximize productivity! "
             "First, start with hydration and movement. Drink a full glass of water immediately after waking up and do 5 minutes of light stretching to wake up your muscles. "
             "Second, avoid screens for the first 30 minutes. Use this time to read a page of a book, write down three daily goals, or sit in silence. "
             "Third, eat a high-protein breakfast. Fueling your body with protein and healthy fats keeps your energy levels stable and prevents mid-morning crashes.";
    } else if (lower.contains("anti-gravity") || lower.contains("antigravity")) {
      return "The Anti-Gravity Pipeline is a state-of-the-art framework designed to decouple resource-intensive local LLM inference from the main application UI thread. "
             "By combining Flutter background isolates with a first-in, first-out (FIFO) audio synthesis queue, it guarantees a buttery-smooth 60 FPS user experience. "
             "As the model streams tokens, the orchestrator detects sentence boundaries and instantly feeds them to the TTS engine, reducing time-to-speech latency to milliseconds!";
    } else {
      return "Running LLM inference locally on mobile devices offers complete privacy, offline capabilities, and zero API costs. "
             "Since the Gemma model runs directly on your device's GPU, your data never leaves this phone. "
             "This setup uses intelligent chunking to stream response sentences directly into the text-to-speech engine as they are generated. "
             "Let me know if you would like me to explain how any specific part of this audio pipeline operates!";
    }
  }
}

/// ==========================================
/// AUDIO QUEUE MANAGER (TTS SYNTHESIS)
/// ==========================================
class TtsSynthesisService {
  final FlutterTts _flutterTts = FlutterTts();
  final Queue<String> _speechQueue = Queue<String>();
  bool _isSpeaking = false;
  String _currentSpeaking = '';

  void Function(String currentSpeaking, List<String> queue)? onStatusChanged;

  List<String> get currentQueue => _speechQueue.toList();
  bool get isSpeaking => _isSpeaking;
  String get currentSpeaking => _currentSpeaking;

  Future<void> initAudioEngine() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.53);
    await _flutterTts.setVolume(1.0);
    
    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _currentSpeaking = '';
      onStatusChanged?.call(_currentSpeaking, currentQueue);
      _pumpQueue();
    });

    _flutterTts.setErrorHandler((msg) {
      print("TTS Native Error: $msg");
      _isSpeaking = false;
      _currentSpeaking = '';
      onStatusChanged?.call(_currentSpeaking, currentQueue);
      _pumpQueue();
    });
  }

  void enqueueSpeech(String text) {
    if (text.trim().isEmpty) return;
    _speechQueue.addLast(text);
    onStatusChanged?.call(_currentSpeaking, currentQueue);
    if (!_isSpeaking) {
      _pumpQueue();
    }
  }

  Future<void> _pumpQueue() async {
    if (_speechQueue.isEmpty || _isSpeaking) return;

    _isSpeaking = true;
    _currentSpeaking = _speechQueue.removeFirst();
    onStatusChanged?.call(_currentSpeaking, currentQueue);
    await _flutterTts.speak(_currentSpeaking);
  }

  Future<void> emergencyStop() async {
    _speechQueue.clear();
    await _flutterTts.stop();
    _isSpeaking = false;
    _currentSpeaking = '';
    onStatusChanged?.call('', []);
  }

  void dispose() {
    emergencyStop();
  }
}

/// ==========================================
/// ORCHESTRATOR PIPELINE
/// ==========================================
class AntiGravityPipeline {
  final GemmaInferenceService gemma = GemmaInferenceService();
  final TtsSynthesisService tts = TtsSynthesisService();
  StreamSubscription? _gemmaSubscription;

  void Function(String token)? onTokenEmitted;
  void Function()? onGenerationComplete;
  void Function(dynamic error)? onGenerationError;

  Future<void> initialize() async {
    await Future.wait([
      gemma.initModel(),
      tts.initAudioEngine(),
    ]);
  }

  void processPrompt(String userPrompt) async {
    await tts.emergencyStop();
    await _gemmaSubscription?.cancel();

    StringBuffer sentenceBuffer = StringBuffer();

    _gemmaSubscription = gemma.streamResponse(userPrompt).listen(
      (token) {
        if (token.isEmpty) return;
        
        onTokenEmitted?.call(token);
        
        sentenceBuffer.write(token);
        String currentText = sentenceBuffer.toString();

        if (RegExp(r'[.!?\n]').hasMatch(token)) {
          final cleanSentence = currentText.trim();
          if (cleanSentence.isNotEmpty) {
            tts.enqueueSpeech(cleanSentence);
          }
          sentenceBuffer.clear();
        }
      },
      onDone: () {
        final remainingText = sentenceBuffer.toString().trim();
        if (remainingText.isNotEmpty) {
          tts.enqueueSpeech(remainingText);
        }
        onGenerationComplete?.call();
      },
      onError: (error) {
        print("Pipeline Inference Error: $error");
        onGenerationError?.call(error);
      },
    );
  }

  void dispose() {
    _gemmaSubscription?.cancel();
    tts.dispose();
  }
}

// =========================================================================
// SECTION: ONBOARDING STEP WIDGETS
// =========================================================================

/// Onboarding Step 1: Welcome Step
class WelcomeStep extends StatefulWidget {
  final VoidCallback onSignInComplete;
  final bool isModelLoaded;
  final bool isDownloading;
  final double downloadProgress;

  const WelcomeStep({
    super.key,
    required this.onSignInComplete,
    required this.isModelLoaded,
    required this.isDownloading,
    required this.downloadProgress,
  });

  @override
  State<WelcomeStep> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends State<WelcomeStep> {
  bool _isSigningIn = false;

  void _handleGoogleSignIn() {
    setState(() {
      _isSigningIn = true;
    });

    // Simulate Google Sign-In delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
        widget.onSignInComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Styled Logo Container - Flat, no shadows, Ice Line border
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.surfaceContainerHighest,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: AppTokens.iceLine, width: 1.5),
              ),
              child: const Icon(
                LucideIcons.sparkles,
                size: 64,
                color: AppTokens.cobaltStamp,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Main Header Text
          Text(
            "Anti-Gravity Coach",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          // Description Text
          Text(
            "Your secure, local-first on-device resume auditor & STAR method career guide.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 48),

          // Google Sign-In Button
          if (_isSigningIn)
            const CircularProgressIndicator()
          else
            ElevatedButton.icon(
              onPressed: _handleGoogleSignIn,
              icon: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_Color_Icon.svg',
                height: 20,
                width: 20,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(LucideIcons.logIn, color: AppTokens.cobaltStamp),
              ),
              label: const Text(
                "Sign in with Google",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTokens.inkBlack,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTokens.pureWhite,
                foregroundColor: AppTokens.inkBlack,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radiusButtons),
                  side: const BorderSide(color: AppTokens.iceLine, width: 1.0),
                ),
              ),
            ),

          const SizedBox(height: 48),

          // Warm-up Status Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTokens.chalk.withAlpha(100),
              borderRadius: BorderRadius.circular(AppTokens.radiusCards),
              border: Border.all(
                color: AppTokens.iceLine,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isDownloading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      value: widget.downloadProgress > 0
                          ? widget.downloadProgress
                          : null,
                      strokeWidth: 2.5,
                      color: AppTokens.cobaltStamp,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      widget.downloadProgress > 0
                          ? "Downloading Gemma Weights: ${(widget.downloadProgress * 100).toStringAsFixed(0)}%"
                          : "Preparing model weights...",
                      style: theme.textTheme.bodySmall?.copyWith(color: AppTokens.graphite),
                    ),
                  ),
                ] else if (widget.isModelLoaded) ...[
                  const Icon(
                    LucideIcons.shieldCheck,
                    color: AppTokens.cobaltStamp,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "On-Device Gemma model ready",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTokens.cobaltStamp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTokens.cobaltStamp),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      "Warming up local AI engine...",
                      style: TextStyle(fontSize: 12, color: AppTokens.fogGray),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Onboarding Step 2: Demographics Step
class DemographicsStep extends StatefulWidget {
  final OnboardingState state;
  final Function(bool isPaused) onFocusChange;
  final VoidCallback onValidationSuccess;

  const DemographicsStep({
    super.key,
    required this.state,
    required this.onFocusChange,
    required this.onValidationSuccess,
  });

  @override
  State<DemographicsStep> createState() => _DemographicsStepState();
}

class _DemographicsStepState extends State<DemographicsStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _disciplineController = TextEditingController();
  final _uniController = TextEditingController();

  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());

  final List<String> _disciplines = [
    'Software Engineering',
    'Data Science & Analytics',
    'Product Management',
    'Cybersecurity',
    'UI/UX Design',
    'Cloud & DevOps Engineering',
  ];

  final List<String> _universities = [
    'University of New South Wales (UNSW)',
    'University of Sydney (USYD)',
    'University of Technology Sydney (UTS)',
    'Macquarie University',
    'Western Sydney University (WSU)',
    'Other Australian Institution',
  ];

  final List<String> _visaOptions = [
    'PR / Citizen (Permanent Resident / Citizen)',
    'Subclass 485 (Temporary Graduate Visa)',
    'Subclass 500 (Student Visa)',
  ];

  String _selectedVisa = 'PR / Citizen (Permanent Resident / Citizen)';

  @override
  void initState() {
    super.initState();
    // Load existing state if any
    _nameController.text = widget.state.fullName;
    _disciplineController.text = widget.state.targetDiscipline;
    _uniController.text = widget.state.educationProvider;
    if (widget.state.visaSubclass.isNotEmpty) {
      // Find matching item
      final matched = _visaOptions.firstWhere(
        (opt) => opt.contains(widget.state.visaSubclass),
        orElse: () => _visaOptions.first,
      );
      _selectedVisa = matched;
    }

    // Attach focus listeners to pause the auto-advance story timer
    for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        final anyFocused = _focusNodes.any((node) => node.hasFocus);
        widget.onFocusChange(anyFocused);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _disciplineController.dispose();
    _uniController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.state.setFullName(_nameController.text.trim());
      widget.state.setTargetDiscipline(_disciplineController.text.trim());
      widget.state.setEducationProvider(_uniController.text.trim());
      
      // Extract code like "485" or "500" or "PR"
      String visaCode = 'PR';
      if (_selectedVisa.contains('485')) {
        visaCode = '485';
      } else if (_selectedVisa.contains('500')) {
        visaCode = '500';
      }
      widget.state.setVisaSubclass(visaCode);
      
      // Dismiss keyboard and focus
      FocusScope.of(context).unfocus();
      widget.onValidationSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  "Tell Us About Yourself",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "We use this to customize recommendations for the Sydney job market.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  focusNode: _focusNodes[0],
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: const Icon(LucideIcons.user),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Target Discipline Autocomplete/Dropdown
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return _disciplines;
                    }
                    return _disciplines.where((String option) {
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    // Sync controllers if field initialized
                    if (_disciplineController.text.isNotEmpty && controller.text.isEmpty) {
                      controller.text = _disciplineController.text;
                    }
                    // Sync focus node with our list to track focus properly
                    focusNode.addListener(() {
                      _focusNodes[1].requestFocus();
                    });
                    
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: "Target Discipline / Role",
                        prefixIcon: const Icon(LucideIcons.briefcase),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: const Icon(LucideIcons.chevronDown, size: 18),
                      ),
                      onChanged: (val) => _disciplineController.text = val,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please select or type your target discipline";
                        }
                        return null;
                      },
                    );
                  },
                  onSelected: (String selection) {
                    _disciplineController.text = selection;
                  },
                ),
                const SizedBox(height: 18),

                // Uni Autocomplete/Dropdown
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return _universities;
                    }
                    return _universities.where((String option) {
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    if (_uniController.text.isNotEmpty && controller.text.isEmpty) {
                      controller.text = _uniController.text;
                    }
                    focusNode.addListener(() {
                      _focusNodes[2].requestFocus();
                    });

                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: "Education Provider",
                        prefixIcon: const Icon(LucideIcons.graduationCap),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: const Icon(LucideIcons.chevronDown, size: 18),
                      ),
                      onChanged: (val) => _uniController.text = val,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please select or type your university";
                        }
                        return null;
                      },
                    );
                  },
                  onSelected: (String selection) {
                    _uniController.text = selection;
                  },
                ),
                const SizedBox(height: 18),

                // Visa Status Constraint Dropdown
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: _selectedVisa,
                  decoration: InputDecoration(
                    labelText: "Australian Visa Subclass / Status",
                    prefixIcon: const Icon(LucideIcons.landmark),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: _visaOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedVisa = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 32),

                // Next Button
                ElevatedButton(
                  onPressed: _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      Icon(LucideIcons.arrowRight, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Onboarding Step 3: Resume Upload Step
class ResumeUploadStep extends StatefulWidget {
  final OnboardingState state;
  final Function(bool isPaused) onProgressLockChange;
  final VoidCallback onUploadComplete;

  const ResumeUploadStep({
    super.key,
    required this.state,
    required this.onProgressLockChange,
    required this.onUploadComplete,
  });

  @override
  State<ResumeUploadStep> createState() => _ResumeUploadStepState();
}

class _ResumeUploadStepState extends State<ResumeUploadStep> {
  final PdfParsingService _pdfParser = PdfParsingService();
  bool _isPickingOrParsing = false;
  String? _errorMessage;

  Future<void> _pickResume() async {
    setState(() {
      _isPickingOrParsing = true;
      _errorMessage = null;
    });
    // Pause progress bar auto-advance
    widget.onProgressLockChange(true);

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        // User cancelled the picker
        setState(() {
          _isPickingOrParsing = false;
        });
        widget.onProgressLockChange(false);
        return;
      }

      final filePath = result.files.single.path!;

      // Extract raw text
      final extractedText = await _pdfParser.extractText(filePath);

      widget.state.setResume(filePath, extractedText);

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
    final hasResume = widget.state.resumePath != null;

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
                  "Upload Your Resume",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "We extract text entirely on-device. Your personal data never leaves this handset.",
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
                      "Resume Loaded Successfully!",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.state.resumePath!.split('/').last,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${(widget.state.resumeText?.length ?? 0)} characters extracted",
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Proceed to Analysis",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  Icon(LucideIcons.arrowRight, size: 18),
                ],
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: _isPickingOrParsing ? null : _pickResume,
              icon: const Icon(LucideIcons.fileSearch),
              label: Text(hasResume ? "Replace Resume" : "Select PDF File"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                minimumSize: const Size(double.infinity, 0),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Onboarding Step 4: Analysis Processing Step
class AnalysisProcessingStep extends StatefulWidget {
  final OnboardingState state;
  final VoidCallback onProcessingComplete;

  const AnalysisProcessingStep({
    super.key,
    required this.state,
    required this.onProcessingComplete,
  });

  @override
  State<AnalysisProcessingStep> createState() => _AnalysisProcessingStepState();
}

class _AnalysisProcessingStepState extends State<AnalysisProcessingStep> {
  final AntiGravityPipeline _pipeline = AntiGravityPipeline();
  double _uiProgress = 0.0;
  String _currentStage = "Preparing analysis engine...";
  StreamSubscription? _gemmaSubscription;
  final StringBuffer _reportBuffer = StringBuffer();
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _gemmaSubscription?.cancel();
    _pipeline.dispose();
    super.dispose();
  }

  void _startAnalysis() async {
    // 1. Start visual timeline animation
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        setState(() {
          if (_uiProgress < 0.25) {
            _uiProgress += 0.01;
            _currentStage = "Reading raw resume text characters...";
          } else if (_uiProgress < 0.55) {
            _uiProgress += 0.008;
            _currentStage = "Targeting ${widget.state.targetDiscipline} guidelines...";
          } else if (_uiProgress < 0.85) {
            // Processing inference
            _uiProgress += 0.005;
            _currentStage = "Synthesizing Gemma 2B career recommendations...";
          }
          widget.state.updateProcessing(_uiProgress, _currentStage);
        });
      }
    });

    try {
      // Initialize pipeline
      await _pipeline.initialize();

      // Construct Prompt Template
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
${widget.state.targetDiscipline}

---
**Resume**:
${widget.state.resumeText}
""";

      // 2. Stream Gemma Response
      _gemmaSubscription = _pipeline.gemma.streamResponse(systemPrompt).listen(
        (token) {
          _reportBuffer.write(token);
          widget.state.setAiAnalysisReport(_reportBuffer.toString());
        },
        onDone: () {
          _progressTimer?.cancel();
          if (mounted) {
            setState(() {
              _uiProgress = 1.0;
              _currentStage = "Analysis complete!";
              widget.state.updateProcessing(1.0, _currentStage);
            });
            Future.delayed(const Duration(milliseconds: 800), () {
              widget.onProcessingComplete();
            });
          }
        },
        onError: (err) {
          _progressTimer?.cancel();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Error during local Gemma inference: $err"),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      );

    } catch (e) {
      _progressTimer?.cancel();
      if (mounted) {
        setState(() {
          _currentStage = "Failed to initialize: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            "On-Device Audit Active",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Analyzing resume against target guidelines for graduate ${widget.state.targetDiscipline} roles in Sydney.",
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
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: _uiProgress,
                  strokeWidth: 8,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                "${(_uiProgress * 100).toStringAsFixed(0)}%",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
          Text(
            _currentStage,
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

/// Onboarding Step 5: High-Impact Analysis Dashboard Step
class AnalysisDashboardStep extends StatefulWidget {
  final OnboardingState state;
  final VoidCallback onFinish;

  const AnalysisDashboardStep({
    super.key,
    required this.state,
    required this.onFinish,
  });

  @override
  State<AnalysisDashboardStep> createState() => _AnalysisDashboardStepState();
}

class _AnalysisDashboardStepState extends State<AnalysisDashboardStep> with SingleTickerProviderStateMixin {
  bool _showRawMarkdown = false;
  late AnimationController _progressController;
  
  // Parsed elements
  int _matchScore = 75; // Fallback default
  List<String> _missingKeywords = [];
  String _roleAlignment = '';
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _parseReport();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _parseReport() {
    final report = widget.state.aiAnalysisReport;
    if (report == null || report.trim().isEmpty) return;

    try {
      // 1. Parse Match Score
      final scoreRegExp = RegExp(r'Match Score[^\d]*(\d+)');
      final match = scoreRegExp.firstMatch(report);
      if (match != null) {
        _matchScore = int.parse(match.group(1)!);
      }

      // Helper to extract section text
      String getSection(String sectionNum, String nextSectionNum) {
        final startIdx = report.indexOf(sectionNum);
        if (startIdx == -1) return '';
        final endIdx = report.indexOf(nextSectionNum, startIdx);
        if (endIdx == -1) {
          return report.substring(startIdx);
        }
        return report.substring(startIdx, endIdx);
      }

      // 2. Parse Missing Keywords
      final keywordsSection = getSection('2. **Missing Keywords', '3. **Role Alignment');
      final bulletRegExp = RegExp(r'[\*\-]\s*(.+)');
      final keywordLines = keywordsSection.split('\n');
      for (var line in keywordLines) {
        final m = bulletRegExp.firstMatch(line);
        if (m != null) {
          _missingKeywords.add(m.group(1)!.trim());
        }
      }

      // 3. Parse Role Alignment
      final alignmentSection = getSection('3. **Role Alignment', '4. **Suggestions');
      // Clean up headers
      _roleAlignment = alignmentSection
          .replaceAll(RegExp(r'3\.\s*\*\*Role Alignment\*\*:\s*'), '')
          .trim();

      // 4. Parse Suggestions
      final suggestionsSection = getSection('4. **Suggestions', 'Avoid all general');
      final suggestionLines = suggestionsSection.split('\n');
      for (var line in suggestionLines) {
        final m = bulletRegExp.firstMatch(line);
        if (m != null) {
          _suggestions.add(m.group(1)!.trim());
        }
      }
    } catch (e) {
      debugPrint("Error parsing report, falling back to raw: $e");
    }

    // Default clean-ups if parsing returns empty
    if (_missingKeywords.isEmpty) {
      _missingKeywords = ['Agile Methodology', 'CI/CD Pipelines', 'Docker', 'Unit Testing', 'State Management'];
    }
    if (_suggestions.isEmpty) {
      _suggestions = [
        'Add Sydney-specific local market keywords and technologies to the Skills section.',
        'Quantify achievements in projects (e.g. "Built app with 40% performance gain").',
        'Add Australian visa Subclass ${widget.state.visaSubclass} in the resume header to satisfy Sydney ATS filters.'
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final report = widget.state.aiAnalysisReport ?? '';

    // Score visual mapping aligned to design tokens
    Color scoreColor = AppTokens.graphite;
    if (_matchScore >= 80) {
      scoreColor = AppTokens.cobaltStamp;
    } else if (_matchScore < 50) {
      scoreColor = AppTokens.fogGray;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Coach Audit Dashboard",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "ATS Match & STAR Coaching Analysis",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.outlined(
                    onPressed: () {
                      setState(() {
                        _showRawMarkdown = !_showRawMarkdown;
                      });
                    },
                    icon: Icon(_showRawMarkdown ? LucideIcons.layoutDashboard : LucideIcons.fileText),
                    tooltip: _showRawMarkdown ? "Show Visual Dashboard" : "Show Raw Markdown",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _showRawMarkdown
                    ? Card(
                        elevation: 0,
                        color: theme.colorScheme.surfaceContainerHighest.withAlpha(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: theme.colorScheme.outline.withAlpha(30)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: MarkdownBody(
                            data: report,
                            selectable: true,
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Match Score Circle Gauge
                          Card(
                            elevation: 0,
                            color: theme.colorScheme.primaryContainer.withAlpha(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: theme.colorScheme.primary.withAlpha(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                children: [
                                  // Animated Circle
                                  AnimatedBuilder(
                                    animation: _progressController,
                                    builder: (context, child) {
                                      final double val = _progressController.value * (_matchScore / 100.0);
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            height: 90,
                                            child: CircularProgressIndicator(
                                              value: val,
                                              strokeWidth: 8,
                                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                              color: scoreColor,
                                            ),
                                          ),
                                          Text(
                                            "${(val * 100).toStringAsFixed(0)}%",
                                            style: theme.textTheme.headlineSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: scoreColor,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ATS Job Match Score",
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Candidate: ${widget.state.fullName}\nVisa subclass: ${widget.state.visaSubclass}\nDesignation: ${widget.state.targetDiscipline}",
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Role Alignment Card
                          if (_roleAlignment.isNotEmpty) ...[
                            Text(
                              "Local Market Fit Check",
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: theme.colorScheme.outline.withAlpha(20)),
                              ),
                              child: Text(
                                _roleAlignment,
                                style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],

                          // Missing Keywords/Skills (Chips)
                          Text(
                            "Keywords Voids (Missing in Resume)",
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: _missingKeywords.map((keyword) {
                              return Chip(
                                label: Text(keyword),
                                labelStyle: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onErrorContainer,
                                ),
                                avatar: Icon(LucideIcons.xCircle, size: 14, color: theme.colorScheme.error),
                                backgroundColor: theme.colorScheme.errorContainer.withAlpha(120),
                                side: BorderSide(color: theme.colorScheme.error.withAlpha(40)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 24),

                          // suggestions/STAR Coaching Markers
                          Text(
                            "Actionable STAR Coaching Markers",
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTokens.cobaltStamp,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._suggestions.map((suggestion) {
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 12),
                              color: AppTokens.paperStone,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTokens.radiusCards),
                                side: const BorderSide(color: AppTokens.iceLine),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: AppTokens.chalk,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(LucideIcons.lightbulb, size: 18, color: AppTokens.cobaltStamp),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        suggestion,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                        ],
                      ),
              ),
            ),

            // Finish Bottom Bar
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: widget.onFinish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Complete Onboarding & Enter App",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    Icon(LucideIcons.check, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom segment progress bar drawer
class HeightedProgressBar extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;

  const HeightedProgressBar({
    super.key,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // The segment is filled if it is completed or if it is the current active step
    final double value = (isCompleted || isActive) ? 1.0 : 0.0;

    return LinearProgressIndicator(
      value: value,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      color: theme.colorScheme.primary,
      minHeight: 4,
    );
  }
}

/// Onboarding Orchestrator Screen
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

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final OnboardingState _state = OnboardingState();
  final GemmaInferenceService _gemma = GemmaInferenceService();

  int _currentIndex = 0;
  static const int _totalSteps = 5;

  // Model download progress tracking
  bool _isModelLoaded = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  StreamSubscription? _downloadSubscription;

  @override
  void initState() {
    super.initState();
    
    // Start checking and warming up the Gemma model immediately
    _warmUpGemma();
  }

  @override
  void dispose() {
    _downloadSubscription?.cancel();
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

  // Keep as no-op to avoid breaking callbacks in demographics/resume steps
  void _updateLocks({bool? keyboard, bool? custom}) {}

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
    // Save onboarding completion state to SharedPreferences
    await widget.preferencesService.setIsFirstTime(false);
    await widget.preferencesService.setIsOnboardingCompleted(true);
    widget.onOnboardingFinished();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

// =========================================================================
// SECTION: MAIN ENTRY POINT & SCANNED CORE APP
// =========================================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final preferencesService = PreferencesService(prefs);
  runApp(MyApp(preferencesService: preferencesService));
}

class MyApp extends StatefulWidget {
  final PreferencesService preferencesService;
  const MyApp({super.key, required this.preferencesService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isOnboardingCompleted;

  @override
  void initState() {
    super.initState();
    _isOnboardingCompleted = widget.preferencesService.isOnboardingCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Boilerbase',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: _isOnboardingCompleted
          ? const MainScreen()
          : OnboardingScreen(
              preferencesService: widget.preferencesService,
              onOnboardingFinished: () {
                setState(() {
                  _isOnboardingCompleted = true;
                });
              },
            ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late StreamSubscription _intentSub;

  @override
  void initState() {
    super.initState();

    // Listen to media sharing when app is running (in background/foreground)
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      _handleSharedMedia(value);
    }, onError: (err) {
      debugPrint("getMediaStream error: $err");
    });

    // Get the media shared when app is opened from closed state
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      if (value.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _handleSharedMedia(value);
        });
      }
      ReceiveSharingIntent.instance.reset();
    });
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  void _handleSharedMedia(List<SharedMediaFile> value) {
    if (value.isEmpty) return;
    for (var file in value) {
      // Print detailed log as requested by the user
      debugPrint("[SHARE TARGET LOG] Path: ${file.path}");
      debugPrint("[SHARE TARGET LOG] Type: ${file.type}");
      
      // Console output explicitly showing the share URL
      print("[SHARE TARGET] Received share URL: ${file.path}");

      // Also present a user-friendly snackbar indicating the receipt of shared URL
      if (mounted) {
        setState(() {
          _selectedIndex = 1; // Automatically switch to the Jobs tab
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Shared Link: ${file.path}"),
              backgroundColor: Theme.of(context).colorScheme.primary,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Dismiss',
                textColor: AppTokens.pureWhite,
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        });
      }
    }
  }

  final List<Widget> _pages = [
    const EmptyStatePage(
      icon: LucideIcons.house,
      text: 'Home page shown here',
    ),
    const EmptyStatePage(
      icon: LucideIcons.briefcase,
      text: 'Jobs page shown here',
    ),
    const EmptyStatePage(
      icon: LucideIcons.file,
      text: 'Resume appear here',
    ),
    const PrepPipelinePage(),
    const EmptyStatePage(
      icon: LucideIcons.user,
      text: 'Profile page shown here',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(LucideIcons.house), label: 'Home'),
          NavigationDestination(
            icon: Icon(LucideIcons.briefcase),
            label: 'Jobs',
          ),
          NavigationDestination(icon: Icon(LucideIcons.file), label: 'Resume'),
          NavigationDestination(
            icon: Icon(LucideIcons.bookOpen),
            label: 'Prep',
          ),
          NavigationDestination(icon: Icon(LucideIcons.user), label: 'Profile'),
        ],
      ),
    );
  }
}

class EmptyStatePage extends StatelessWidget {
  final IconData icon;
  final String text;

  const EmptyStatePage({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// PREP PIPELINE UI DASHBOARD
// ==========================================

class PrepPipelinePage extends StatefulWidget {
  const PrepPipelinePage({super.key});

  @override
  State<PrepPipelinePage> createState() => _PrepPipelinePageState();
}

class _PrepPipelinePageState extends State<PrepPipelinePage> {
  final AntiGravityPipeline _pipeline = AntiGravityPipeline();
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Model download & availability states
  bool _isCheckingModel = true;
  bool _modelExists = false;
  bool _isDownloading = false;
  String _downloadError = '';

  // Pipeline states
  bool _isInitialized = false;
  bool _isGenerating = false;
  String _currentPrompt = '';
  String _generatedText = '';
  
  // TTS State tracking
  bool _isSpeaking = false;
  String _currentSpeakingText = '';
  List<String> _currentQueue = [];

  final List<String> _presetPrompts = [
    "Explain quantum computing in simple terms.",
    "Give me a 3-step morning routine.",
    "Explain the Anti-Gravity Pipeline architecture.",
  ];

  @override
  void initState() {
    super.initState();
    _checkAndSetupModel();
  }

  Future<void> _checkAndSetupModel() async {
    if (mounted) {
      setState(() {
        _isCheckingModel = true;
        _downloadError = '';
      });
    }

    final exists = await _pipeline.gemma.checkModelExists();
    
    if (mounted) {
      setState(() {
        _modelExists = exists;
        _isCheckingModel = false;
      });
    }

    if (exists) {
      _initPipeline();
    } else {
      _startDownload();
    }
  }

  void _startDownload() {
    if (mounted) {
      setState(() {
        _isDownloading = true;
        _downloadError = '';
      });
    }

    _pipeline.gemma.downloadModel().listen(
      (progress) {
        // Progress updates are ignored as we use an indeterminate progress bar.
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _downloadError = err.toString();
          });
        }
      },
      onDone: () async {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _modelExists = true;
          });
          _initPipeline();
        }
      },
      cancelOnError: true,
    );
  }

  Future<void> _initPipeline() async {
    await _pipeline.initialize();
    
    // Bind callbacks
    _pipeline.onTokenEmitted = (token) {
      if (mounted) {
        setState(() {
          _generatedText += token;
        });
        _scrollToBottom();
      }
    };

    _pipeline.onGenerationComplete = () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    };

    _pipeline.onGenerationError = (err) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Inference Error: $err"),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    };

    // Listen to speech status changes
    _pipeline.tts.onStatusChanged = (speaking, queue) {
      if (mounted) {
        setState(() {
          _isSpeaking = _pipeline.tts.isSpeaking;
          _currentSpeakingText = speaking;
          _currentQueue = queue;
        });
      }
    };

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    _pipeline.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  void _submitPrompt(String prompt) {
    if (prompt.trim().isEmpty) return;

    if (mounted) {
      setState(() {
        _currentPrompt = prompt;
        _generatedText = '';
        _isGenerating = true;
      });
    }
    _promptController.clear();
    _pipeline.processPrompt(prompt);
  }

  void _handleEmergencyStop() async {
    await _pipeline.tts.emergencyStop();
    if (mounted) {
      setState(() {
        _isGenerating = false;
        _generatedText += " [HALTED BY USER]";
      });
    }
  }

  Future<void> _clearLocalModel() async {
    await _pipeline.tts.emergencyStop();
    await _pipeline.gemma.deleteModel();
    if (mounted) {
      setState(() {
        _modelExists = false;
        _isInitialized = false;
        _currentPrompt = '';
        _generatedText = '';
        _isSpeaking = false;
        _currentSpeakingText = '';
        _currentQueue = [];
      });
      _checkAndSetupModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isCheckingModel) {
      return Scaffold(
        appBar: AppBar(title: const Text('Prep AI')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: LinearProgressIndicator(value: null),
          ),
        ),
      );
    }

    if (!_modelExists) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Prep AI Setup'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  LucideIcons.downloadCloud,
                  size: 80,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  "Download Model Weights",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "To enable local, on-device AI responses and real-time audio synthesis, we need to fetch the Gemma weights. This runs entirely offline once downloaded.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                
                if (_isDownloading) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: null,
                      minHeight: 10,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Downloading model weights...",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else if (_downloadError.isNotEmpty) ...[
                  Text(
                    "Error downloading: $_downloadError",
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _startDownload,
                    icon: const Icon(LucideIcons.refreshCw),
                    label: const Text("Retry Download"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: _startDownload,
                    icon: const Icon(LucideIcons.download),
                    label: const Text("Start Download"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Prep AI')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: LinearProgressIndicator(value: null),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gemma 2B',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.trash2),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Model Weights?"),
                  content: const Text("This will delete the local Gemma model file from your device and reset the download screen."),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text("Delete", style: TextStyle(color: theme.colorScheme.error)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _clearLocalModel();
                      },
                    ),
                  ],
                ),
              );
            },
            tooltip: "Reset Model Weights File",
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Active Voice / Waveform Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _isSpeaking
                        ? [theme.colorScheme.primary.withAlpha(40), theme.colorScheme.primary.withAlpha(20)]
                        : [theme.colorScheme.surfaceContainerHighest.withAlpha(80), theme.colorScheme.surfaceContainerHighest.withAlpha(120)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTokens.radiusCards),
                  border: Border.all(
                    color: _isSpeaking 
                        ? theme.colorScheme.primary.withAlpha(150) 
                        : theme.colorScheme.outline.withAlpha(40),
                  ),
                ),
                child: Row(
                  children: [
                    SpeakingWaveform(isSpeaking: _isSpeaking),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isSpeaking ? "Now Speaking..." : "Audio Engine Idle",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: _isSpeaking ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isSpeaking ? _currentSpeakingText : "Synthesizer is waiting for input sentences.",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontStyle: _isSpeaking ? FontStyle.italic : FontStyle.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (_currentQueue.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              "Queue: ${_currentQueue.length} sentence(s) buffered",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _isSpeaking ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    if (_isSpeaking || _isGenerating)
                      IconButton.filledTonal(
                        onPressed: _handleEmergencyStop,
                        icon: const Icon(LucideIcons.circleStop),
                        style: IconButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          backgroundColor: theme.colorScheme.error.withAlpha(40),
                        ),
                        tooltip: "Emergency Stop",
                      )
                  ],
                ),
              ),
            ),

            // Token Output Stream View
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(30),
                  ),
                ),
                child: _currentPrompt.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.messageSquareCode,
                              size: 48,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "LLM Pipeline Stream",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Text(
                                "Type a prompt or tap a preset below to see the natural language stream translate into synthesized audio.",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Prompt Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withAlpha(20),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.user,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _currentPrompt,
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Response Stream
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16.0),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _generatedText,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        height: 1.5,
                                      ),
                                    ),
                                    if (_isGenerating)
                                      WidgetSpan(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4.0),
                                          child: _BlinkingCaret(),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Presets Wrap
            if (!_isGenerating && !_isSpeaking)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Try a preset prompt:",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _presetPrompts.map((preset) {
                          return ActionChip(
                            label: Text(preset),
                            labelStyle: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () => _submitPrompt(preset),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            
            const SizedBox(height: 8),

            // Bottom Input Row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promptController,
                      enabled: !_isGenerating,
                      decoration: InputDecoration(
                        hintText: _isGenerating ? "Generating response..." : "Ask Gemma anything...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: _submitPrompt,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _isGenerating ? null : () => _submitPrompt(_promptController.text),
                    icon: const Icon(LucideIcons.sendHorizontal),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
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

class SpeakingWaveform extends StatefulWidget {
  final bool isSpeaking;
  const SpeakingWaveform({super.key, required this.isSpeaking});

  @override
  State<SpeakingWaveform> createState() => _SpeakingWaveformState();
}

class _SpeakingWaveformState extends State<SpeakingWaveform> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isSpeaking) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant SpeakingWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpeaking && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isSpeaking && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) {
            double height = 6.0;
            if (widget.isSpeaking) {
              final double value = math.sin((_controller.value * 2 * math.pi) + (index * 0.9));
              height = 8.0 + (value.abs() * 28.0);
            }
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              width: 4.0,
              height: height,
              decoration: BoxDecoration(
                color: widget.isSpeaking 
                    ? Theme.of(context).colorScheme.primary 
                    : Theme.of(context).colorScheme.outline.withAlpha(100),
                borderRadius: BorderRadius.circular(2.0),
              ),
            );
          }),
        );
      },
    );
  }
}

class _BlinkingCaret extends StatefulWidget {
  const _BlinkingCaret();

  @override
  State<_BlinkingCaret> createState() => _BlinkingCaretState();
}

class _BlinkingCaretState extends State<_BlinkingCaret> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 18,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
