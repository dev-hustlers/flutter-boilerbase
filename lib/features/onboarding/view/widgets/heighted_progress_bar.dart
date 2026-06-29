import 'package:flutter/material.dart';

/// Custom segment progress bar drawer.
class HeightedProgressBar extends StatelessWidget {
  final bool isActive;
  final bool isCompleted;

  const HeightedProgressBar({
    super.key,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // The segment is filled if it is completed or if it is the current active step
    final double value = (isCompleted || isActive) ? 1.0 : 0.0;

    return LinearProgressIndicator(
      value: value,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      color: theme.colorScheme.primary,
      minHeight: 4,
    );
  }
}
