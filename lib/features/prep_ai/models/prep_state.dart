/// State class representing model presence, downloads, and inference/TTS streaming state.
class PrepState {
  final bool isCheckingModel;
  final bool modelExists;
  final bool isDownloading;
  final String downloadError;
  final bool isInitialized;
  final bool isGenerating;
  final String currentPrompt;
  final String generatedText;
  final bool isSpeaking;
  final String currentSpeakingText;
  final List<String> currentQueue;

  PrepState({
    this.isCheckingModel = true,
    this.modelExists = false,
    this.isDownloading = false,
    this.downloadError = '',
    this.isInitialized = false,
    this.isGenerating = false,
    this.currentPrompt = '',
    this.generatedText = '',
    this.isSpeaking = false,
    this.currentSpeakingText = '',
    this.currentQueue = const [],
  });

  PrepState copyWith({
    bool? isCheckingModel,
    bool? modelExists,
    bool? isDownloading,
    String? downloadError,
    bool? isInitialized,
    bool? isGenerating,
    String? currentPrompt,
    String? generatedText,
    bool? isSpeaking,
    String? currentSpeakingText,
    List<String>? currentQueue,
  }) {
    return PrepState(
      isCheckingModel: isCheckingModel ?? this.isCheckingModel,
      modelExists: modelExists ?? this.modelExists,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadError: downloadError ?? this.downloadError,
      isInitialized: isInitialized ?? this.isInitialized,
      isGenerating: isGenerating ?? this.isGenerating,
      currentPrompt: currentPrompt ?? this.currentPrompt,
      generatedText: generatedText ?? this.generatedText,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      currentSpeakingText: currentSpeakingText ?? this.currentSpeakingText,
      currentQueue: currentQueue ?? this.currentQueue,
    );
  }
}
