import 'dart:async';
import 'gemma_inference_service.dart';
import 'tts_synthesis_service.dart';

/// Orchestrates the local pipeline, feeding Gemma stream outputs into the TTS queue.
class AntiGravityPipeline {
  final GemmaInferenceService gemma;
  final TtsSynthesisService tts;
  StreamSubscription? _gemmaSubscription;

  void Function(String token)? onTokenEmitted;
  void Function()? onGenerationComplete;
  void Function(dynamic error)? onGenerationError;

  AntiGravityPipeline({
    required this.gemma,
    required this.tts,
  });

  Future<void> initialize() async {
    await Future.wait([
      gemma.initModel(),
      tts.initAudioEngine(),
    ]);
  }

  void processPrompt(String userPrompt) async {
    await tts.emergencyStop();
    await _gemmaSubscription?.cancel();

    final sentenceBuffer = StringBuffer();

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
        // ignore: avoid_print
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
