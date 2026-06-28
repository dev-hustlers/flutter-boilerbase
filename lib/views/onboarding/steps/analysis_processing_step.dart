import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../models/onboarding_state.dart';
import '../../../main.dart'; // To access AntiGravityPipeline / Gemma

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
