import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prep_state.dart';
import '../../../core/providers/service_providers.dart';

/// ViewModel driving the offline Gemma download, LLM prompt generation, and TTS queue.
class PrepAiViewModel extends AutoDisposeNotifier<PrepState> {
  StreamSubscription? _downloadSubscription;

  @override
  PrepState build() {
    ref.onDispose(() {
      _downloadSubscription?.cancel();
      // Ensure we release pipeline resources when leaving the screen
      final pipeline = ref.read(antiGravityPipelineProvider);
      pipeline.dispose();
    });

    // Check and setup model on initialization
    _checkAndSetupModel();

    return PrepState();
  }

  Future<void> _checkAndSetupModel() async {
    state = state.copyWith(isCheckingModel: true, downloadError: '');

    final pipeline = ref.read(antiGravityPipelineProvider);
    final exists = await pipeline.gemma.checkModelExists();

    state = state.copyWith(
      modelExists: exists,
      isCheckingModel: false,
    );

    if (exists) {
      _initPipeline();
    }
  }

  void startDownload() {
    state = state.copyWith(isDownloading: true, downloadError: '');
    final pipeline = ref.read(antiGravityPipelineProvider);

    _downloadSubscription?.cancel();
    _downloadSubscription = pipeline.gemma.downloadModel().listen(
      (progress) {
        // Indeterminate progress representation in UI
      },
      onError: (err) {
        state = state.copyWith(
          isDownloading: false,
          downloadError: err.toString(),
        );
      },
      onDone: () async {
        state = state.copyWith(
          isDownloading: false,
          modelExists: true,
        );
        _initPipeline();
      },
      cancelOnError: true,
    );
  }

  Future<void> _initPipeline() async {
    final pipeline = ref.read(antiGravityPipelineProvider);
    await pipeline.initialize();

    // Bind token streaming callbacks
    pipeline.onTokenEmitted = (token) {
      state = state.copyWith(
        generatedText: state.generatedText + token,
      );
    };

    pipeline.onGenerationComplete = () {
      state = state.copyWith(isGenerating: false);
    };

    pipeline.onGenerationError = (err) {
      state = state.copyWith(
        isGenerating: false,
        downloadError: err.toString(),
      );
    };

    // Listen to real-time TTS speech queue updates
    pipeline.tts.onStatusChanged = (speaking, queue) {
      state = state.copyWith(
        isSpeaking: pipeline.tts.isSpeaking,
        currentSpeakingText: speaking,
        currentQueue: queue,
      );
    };

    state = state.copyWith(isInitialized: true);
  }

  void submitPrompt(String prompt) {
    if (prompt.trim().isEmpty) return;

    state = state.copyWith(
      currentPrompt: prompt,
      generatedText: '',
      isGenerating: true,
    );

    final pipeline = ref.read(antiGravityPipelineProvider);
    pipeline.processPrompt(prompt);
  }

  Future<void> handleEmergencyStop() async {
    final pipeline = ref.read(antiGravityPipelineProvider);
    await pipeline.tts.emergencyStop();
    state = state.copyWith(
      isGenerating: false,
      generatedText: '${state.generatedText} [HALTED BY USER]',
    );
  }

  Future<void> clearLocalModel() async {
    final pipeline = ref.read(antiGravityPipelineProvider);
    await pipeline.tts.emergencyStop();
    await pipeline.gemma.deleteModel();

    state = PrepState(
      isCheckingModel: false,
      modelExists: false,
      isInitialized: false,
    );
  }
}

final prepAiViewModelProvider = AutoDisposeNotifierProvider<PrepAiViewModel, PrepState>(() {
  return PrepAiViewModel();
});
