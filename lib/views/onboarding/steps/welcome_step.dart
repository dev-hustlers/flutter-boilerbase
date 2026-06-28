import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_boilerbase/theme/app_theme.dart';

class WelcomeStep extends StatefulWidget {
  final VoidCallback onSignInComplete;
  final bool isModelLoaded;
  final bool isDownloading;
  final double downloadProgress;

  const WelcomeStep({
    super.key,
    required this.onSignInComplete,
    required this.isModelLoaded,
    required this.isDownloading,
    required this.downloadProgress,
  });

  @override
  State<WelcomeStep> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends State<WelcomeStep>
    with SingleTickerProviderStateMixin {
  bool _isSigningIn = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleGoogleSignIn() async {
    setState(() {
      _isSigningIn = true;
    });

    // Simulate Google Sign-In delay
    await Future.delayed(const Duration(seconds: 1500 ~/ 1000));

    if (mounted) {
      setState(() {
        _isSigningIn = false;
      });
      widget.onSignInComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // App Logo / Symbol
          ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.05).animate(
              CurvedAnimation(
                parent: _pulseController,
                curve: Curves.easeInOut,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.surfaceContainerHighest,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: AppTokens.iceLine, width: 1.5),
              ),
              child: const Icon(
                LucideIcons.sparkles,
                size: 64,
                color: AppTokens.cobaltStamp,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            "Sydney Career Coach",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Local-first, privacy-focused AI career optimization for Australian graduates & freshers.",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),

          // Google Sign-In Button
          if (_isSigningIn)
            const CircularProgressIndicator()
          else
            ElevatedButton.icon(
              onPressed: _handleGoogleSignIn,
              icon: Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_Color_Icon.svg',
                height: 20,
                width: 20,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(LucideIcons.logIn, color: AppTokens.cobaltStamp),
              ),
              label: const Text(
                "Sign in with Google",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTokens.inkBlack,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTokens.pureWhite,
                foregroundColor: AppTokens.inkBlack,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radiusButtons),
                  side: const BorderSide(color: AppTokens.iceLine, width: 1.0),
                ),
              ),
            ),

          const SizedBox(height: 48),

          // Warm-up Status Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTokens.chalk.withAlpha(100),
              borderRadius: BorderRadius.circular(AppTokens.radiusCards),
              border: Border.all(
                color: AppTokens.iceLine,
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isDownloading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      value: widget.downloadProgress > 0
                          ? widget.downloadProgress
                          : null,
                      strokeWidth: 2.5,
                      color: AppTokens.cobaltStamp,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      widget.downloadProgress > 0
                          ? "Downloading Gemma Weights: ${(widget.downloadProgress * 100).toStringAsFixed(0)}%"
                          : "Preparing model weights...",
                      style: theme.textTheme.bodySmall?.copyWith(color: AppTokens.graphite),
                    ),
                  ),
                ] else if (widget.isModelLoaded) ...[
                  const Icon(
                    LucideIcons.shieldCheck,
                    color: AppTokens.cobaltStamp,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "On-Device Gemma model ready",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTokens.cobaltStamp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTokens.cobaltStamp),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      "Warming up local AI engine...",
                      style: TextStyle(fontSize: 12, color: AppTokens.fogGray),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
