import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:catalyst/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../main_screen/view/main_screen.dart';
import '../../onboarding/view/onboarding_screen.dart';
import '../view_model/splash_view_model.dart';

/// Splash screen shown on application load.
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Listen to the navigation target emitted by the ViewModel
    ref.listen<SplashNavigationTarget>(splashViewModelProvider, (previous, next) {
      if (next == SplashNavigationTarget.onboarding) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      } else if (next == SplashNavigationTarget.mainScreen) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppTokens.surfaceContainerLowest,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Brand Logo container with brand-mark radius (120px circular)
            Container(
              width: 120.0,
              height: 120.0,
              decoration: BoxDecoration(
                color: AppTokens.surfaceContainerLowest,
                shape: BoxShape.circle,
                border: Border.all(color: AppTokens.outlineVariant, width: 1.5),
              ),
              child: const Icon(
                LucideIcons.briefcase,
                size: 54,
                color: AppTokens.primary,
              ),
            ),
            const SizedBox(height: 32.0),
            // Title
            Text(
              l10n.splashTitle,
              style: theme.textTheme.headlineLarge?.copyWith(
                color: AppTokens.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12.0),
            // Subtitle
            Text(
              l10n.splashSubtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTokens.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
