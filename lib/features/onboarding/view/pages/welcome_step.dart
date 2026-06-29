import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:catalyst/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

/// Onboarding Step 1: Welcome Step Page.
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

class _WelcomeStepState extends State<WelcomeStep> {
  bool _isSigningIn = false;

  void _handleGoogleSignIn() {
    setState(() {
      _isSigningIn = true;
    });

    // Simulate Google Sign-In delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
        widget.onSignInComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Styled Logo Container - Flat, no shadows, outline border
          Center(
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
                border: Border.all(color: AppTokens.outlineVariant, width: 1.5),
              ),
              child: const Icon(
                LucideIcons.sparkles,
                size: 64,
                color: AppTokens.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Main Header Text
          Text(
            l10n.welcomeTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),

          // Description Text
          Text(
            l10n.welcomeSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 48),

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
                    const Icon(LucideIcons.logIn, color: AppTokens.primary),
              ),
              label: Text(
                l10n.googleSignIn,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTokens.onSurface,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTokens.surfaceContainerLowest,
                foregroundColor: AppTokens.onSurface,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTokens.radiusLg),
                  side: const BorderSide(color: AppTokens.outlineVariant, width: 1.0),
                ),
              ),
            ),

          const SizedBox(height: 48),

          // Warm-up Status Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTokens.surfaceContainer.withAlpha(100),
              borderRadius: BorderRadius.circular(AppTokens.radiusLg),
              border: Border.all(
                color: AppTokens.outlineVariant,
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
                      color: AppTokens.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      widget.downloadProgress > 0
                          ? l10n.downloadProgress((widget.downloadProgress * 100).toStringAsFixed(0))
                          : l10n.downloadingLocalAiBrain,
                      style: theme.textTheme.bodySmall?.copyWith(color: AppTokens.onSurfaceVariant),
                    ),
                  ),
                ] else if (widget.isModelLoaded) ...[
                  const Icon(
                    LucideIcons.shieldCheck,
                    color: AppTokens.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      l10n.localAiBrainActive,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTokens.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppTokens.primary),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      "Warming up local AI engine...",
                      style: TextStyle(fontSize: 12, color: AppTokens.onSurfaceVariant),
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
