import 'dart:collection';
import 'package:flutter_tts/flutter_tts.dart';

/// Service managing sequential text-to-speech rendering of sentences generated in isolates/streams.
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
      // ignore: avoid_print
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
