import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/service_providers.dart';

/// Navigation targets from Splash Screen.
enum SplashNavigationTarget {
  loading,
  onboarding,
  mainScreen,
}

/// ViewModel that checks initialization and decides where to navigate.
class SplashViewModel extends AutoDisposeNotifier<SplashNavigationTarget> {
  @override
  SplashNavigationTarget build() {
    _initSplash();
    return SplashNavigationTarget.loading;
  }

  Future<void> _initSplash() async {
    // Show splash screen for 1.5 seconds minimum
    await Future.delayed(const Duration(milliseconds: 1500));
    final prefs = ref.read(preferencesServiceProvider);
    
    if (prefs.isOnboardingCompleted) {
      state = SplashNavigationTarget.mainScreen;
    } else {
      state = SplashNavigationTarget.onboarding;
    }
  }
}

final splashViewModelProvider = AutoDisposeNotifierProvider<SplashViewModel, SplashNavigationTarget>(() {
  return SplashViewModel();
});
