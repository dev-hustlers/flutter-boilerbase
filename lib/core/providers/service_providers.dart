import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/pdf_parsing_service.dart';
import '../services/preferences_service.dart';
import '../services/gemma_inference_service.dart';
import '../services/tts_synthesis_service.dart';
import '../services/anti_gravity_pipeline.dart';

/// Provider for [SharedPreferences]. Must be overridden in main entry point.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized');
});

/// Provider for [PreferencesService].
final preferencesServiceProvider = Provider<PreferencesService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PreferencesService(prefs);
});

/// Provider for [PdfParsingService].
final pdfParsingServiceProvider = Provider<PdfParsingService>((ref) {
  return PdfParsingService();
});

/// Provider for [GemmaInferenceService].
final gemmaInferenceServiceProvider = Provider<GemmaInferenceService>((ref) {
  return GemmaInferenceService();
});

/// Provider for [TtsSynthesisService].
final ttsSynthesisServiceProvider = Provider<TtsSynthesisService>((ref) {
  return TtsSynthesisService();
});

/// Provider for [AntiGravityPipeline].
final antiGravityPipelineProvider = Provider<AntiGravityPipeline>((ref) {
  final gemma = ref.watch(gemmaInferenceServiceProvider);
  final tts = ref.watch(ttsSynthesisServiceProvider);
  return AntiGravityPipeline(gemma: gemma, tts: tts);
});
