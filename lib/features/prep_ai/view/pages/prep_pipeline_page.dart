import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:catalyst/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../view_model/prep_ai_view_model.dart';
import '../widgets/speaking_waveform.dart';
import '../widgets/blinking_caret.dart';

class PrepPipelinePage extends ConsumerStatefulWidget {
  const PrepPipelinePage({super.key});

  @override
  ConsumerState<PrepPipelinePage> createState() => _PrepPipelinePageState();
}

class _PrepPipelinePageState extends ConsumerState<PrepPipelinePage> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
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
    ref.read(prepAiViewModelProvider.notifier).submitPrompt(prompt);
    _promptController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final prepState = ref.watch(prepAiViewModelProvider);

    // Auto-scroll on new text tokens
    ref.listen(prepAiViewModelProvider.select((s) => s.generatedText), (_, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });

    final List<String> presetPrompts = [
      l10n.presetQuantum,
      l10n.presetRoutine,
      l10n.presetPipeline,
    ];

    if (prepState.isCheckingModel) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.prepAi)),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: LinearProgressIndicator(value: null),
          ),
        ),
      );
    }

    if (!prepState.modelExists) {
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
                
                if (prepState.isDownloading) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(
                      value: null,
                      minHeight: 10,
                      backgroundColor: AppTokens.outlineVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Downloading model weights...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ] else if (prepState.downloadError.isNotEmpty) ...[
                  Text(
                    "Error downloading: ${prepState.downloadError}",
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => ref.read(prepAiViewModelProvider.notifier).startDownload(),
                    icon: const Icon(LucideIcons.refreshCw),
                    label: const Text("Retry Download"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: () => ref.read(prepAiViewModelProvider.notifier).startDownload(),
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

    if (!prepState.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.prepAi)),
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
                  title: Text(l10n.deleteModelWeights),
                  content: Text(l10n.deleteModelWeightsDescription),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text("Delete", style: TextStyle(color: theme.colorScheme.error)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(prepAiViewModelProvider.notifier).clearLocalModel();
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
                    colors: prepState.isSpeaking
                        ? [theme.colorScheme.primary.withAlpha(40), theme.colorScheme.primary.withAlpha(20)]
                        : [theme.colorScheme.surfaceContainerHighest.withAlpha(80), theme.colorScheme.surfaceContainerHighest.withAlpha(120)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                  border: Border.all(
                    color: prepState.isSpeaking 
                        ? theme.colorScheme.primary.withAlpha(150) 
                        : theme.colorScheme.outline.withAlpha(40),
                  ),
                ),
                child: Row(
                  children: [
                    SpeakingWaveform(isSpeaking: prepState.isSpeaking),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prepState.isSpeaking ? l10n.nowSpeaking : l10n.audioEngineIdle,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: prepState.isSpeaking ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            prepState.isSpeaking ? prepState.currentSpeakingText : l10n.synthesizerIdle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontStyle: prepState.isSpeaking ? FontStyle.italic : FontStyle.normal,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (prepState.currentQueue.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              "Queue: ${prepState.currentQueue.length} sentence(s) buffered",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: prepState.isSpeaking ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                    if (prepState.isSpeaking || prepState.isGenerating)
                      IconButton.filledTonal(
                        onPressed: () => ref.read(prepAiViewModelProvider.notifier).handleEmergencyStop(),
                        icon: const Icon(LucideIcons.circleStop),
                        style: IconButton.styleFrom(
                          foregroundColor: theme.colorScheme.error,
                          backgroundColor: theme.colorScheme.error.withAlpha(40),
                        ),
                        tooltip: l10n.emergencyStop,
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
                child: prepState.currentPrompt.isEmpty
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
                              l10n.llmPipelineStream,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 32.0),
                              child: Text(
                                l10n.llmStreamSubtitle,
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
                                    prepState.currentPrompt,
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
                                      text: prepState.generatedText,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        height: 1.5,
                                      ),
                                    ),
                                    if (prepState.isGenerating)
                                      const WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 4.0),
                                          child: BlinkingCaret(),
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
            if (!prepState.isGenerating && !prepState.isSpeaking)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.tryPresetPrompt,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: presetPrompts.map((preset) {
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
                      enabled: !prepState.isGenerating,
                      decoration: InputDecoration(
                        hintText: prepState.isGenerating ? l10n.generatingResponse : l10n.askGemmaAnything,
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
                    onPressed: prepState.isGenerating ? null : () => _submitPrompt(_promptController.text),
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
