import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';

/// State representing cached model status and active download progress.
class GemmaStatusState {
  final bool isLoaded;
  final bool isDownloading;
  final double downloadProgress;

  GemmaStatusState({
    this.isLoaded = false,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
  });

  GemmaStatusState copyWith({
    bool? isLoaded,
    bool? isDownloading,
    double? downloadProgress,
  }) {
    return GemmaStatusState(
      isLoaded: isLoaded ?? this.isLoaded,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }
}

/// Notifier warming up Gemma weights and tracking download progress.
class GemmaStatusNotifier extends AutoDisposeNotifier<GemmaStatusState> {
  StreamSubscription? _downloadSubscription;

  @override
  GemmaStatusState build() {
    _warmUpGemma();
    ref.onDispose(() {
      _downloadSubscription?.cancel();
    });
    return GemmaStatusState();
  }

  Future<void> _warmUpGemma() async {
    final gemma = ref.read(gemmaInferenceServiceProvider);
    final exists = await gemma.checkModelExists();
    if (exists) {
      state = GemmaStatusState(isLoaded: true, isDownloading: false);
    } else {
      state = GemmaStatusState(isLoaded: false, isDownloading: true, downloadProgress: 0.0);
      _downloadSubscription = gemma.downloadModel().listen(
        (progress) {
          state = state.copyWith(downloadProgress: progress);
        },
        onError: (err) {
          state = GemmaStatusState(isLoaded: false, isDownloading: false);
        },
        onDone: () {
          state = GemmaStatusState(isLoaded: true, isDownloading: false);
        },
        cancelOnError: true,
      );
    }
  }
}

final gemmaStatusProvider = AutoDisposeNotifierProvider<GemmaStatusNotifier, GemmaStatusState>(() {
  return GemmaStatusNotifier();
});
