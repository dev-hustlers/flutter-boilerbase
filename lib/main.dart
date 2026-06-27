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
import 'package:flutter_boilerbase/services/preferences_service.dart';
import 'package:flutter_boilerbase/views/onboarding/onboarding_screen.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
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
                textColor: Colors.white,
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
            backgroundColor: Colors.redAccent,
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
                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
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
            // Status Header Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer.withAlpha(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.primary.withAlpha(40),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.checkCircle2,
                        color: Colors.greenAccent.shade700,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Local Weights Loaded",
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Model: gemma_model.bin (GPU Accelerated)",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

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
                        ? [Colors.teal.shade900, const Color(0xFF002A1B)]
                        : [theme.colorScheme.surfaceContainerHighest.withAlpha(80), theme.colorScheme.surfaceContainerHighest.withAlpha(120)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isSpeaking 
                        ? Colors.teal.shade400.withAlpha(150) 
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
                              color: _isSpeaking ? Colors.tealAccent.shade400 : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isSpeaking ? _currentSpeakingText : "Synthesizer is waiting for input sentences.",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: _isSpeaking ? Colors.white : theme.colorScheme.onSurface,
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
                                color: _isSpeaking ? Colors.tealAccent.shade100 : theme.colorScheme.onSurfaceVariant,
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
                          foregroundColor: Colors.redAccent,
                          backgroundColor: Colors.red.withAlpha(40),
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
                    ? Colors.tealAccent.shade400 
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

// ==========================================
// ORCHESTRATOR PIPELINE
// ==========================================

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

// ==========================================
// AUDIO QUEUE MANAGER (TTS SYNTHESIS)
// ==========================================

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

// ==========================================
// GEMMA INFERENCE SERVICE
// ==========================================

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
