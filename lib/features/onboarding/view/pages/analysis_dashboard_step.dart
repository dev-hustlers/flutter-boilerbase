import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:catalyst/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../view_model/onboarding_view_model.dart';

class AnalysisDashboardStep extends ConsumerStatefulWidget {
  final VoidCallback onFinish;

  const AnalysisDashboardStep({
    super.key,
    required this.onFinish,
  });

  @override
  ConsumerState<AnalysisDashboardStep> createState() => _AnalysisDashboardStepState();
}

class _AnalysisDashboardStepState extends ConsumerState<AnalysisDashboardStep> with SingleTickerProviderStateMixin {
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
    final onboardingState = ref.read(onboardingViewModelProvider);
    final report = onboardingState.aiAnalysisReport;
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
        'Add Australian visa Subclass ${onboardingState.visaSubclass} in the resume header to satisfy Sydney ATS filters.'
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final onboardingState = ref.watch(onboardingViewModelProvider);
    final report = onboardingState.aiAnalysisReport ?? '';

    // Score visual mapping aligned to design tokens
    Color scoreColor = AppTokens.onSurface;
    if (_matchScore >= 80) {
      scoreColor = AppTokens.primary;
    } else if (_matchScore < 50) {
      scoreColor = AppTokens.onSurfaceVariant;
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
                          l10n.resumeAnalysisDashboard,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          l10n.basedOnGemma,
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
                                          l10n.matchScore,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Candidate: ${onboardingState.fullName}\nVisa subclass: ${onboardingState.visaSubclass}\nDesignation: ${onboardingState.targetDiscipline}",
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
                            l10n.keywordVoids,
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
                            l10n.starCoachingMarkers,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTokens.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._suggestions.map((suggestion) {
                            return Card(
                              elevation: 0,
                              margin: const EdgeInsets.only(bottom: 12),
                              color: AppTokens.surfaceContainerLow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                                side: const BorderSide(color: AppTokens.outlineVariant),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: AppTokens.surfaceContainer,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(LucideIcons.lightbulb, size: 18, color: AppTokens.primary),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.completeOnboarding,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    const Icon(LucideIcons.check, size: 18),
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
