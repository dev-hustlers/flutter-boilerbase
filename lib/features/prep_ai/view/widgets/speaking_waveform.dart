import 'dart:math' as math;
import 'package:flutter/material.dart';

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
                    ? Theme.of(context).colorScheme.primary 
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
