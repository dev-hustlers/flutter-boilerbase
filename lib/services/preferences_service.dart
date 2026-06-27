import 'package:shared_preferences/shared_preferences.dart';

/// A service to manage app-wide preferences stored in SharedPreferences.
class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  /// Checks if the user is running the app for the first time.
  /// Default: `true`
  bool get isFirstTime => _prefs.getBool('isFirstTime') ?? true;

  /// Updates whether the user is running the app for the first time.
  Future<bool> setIsFirstTime(bool value) => _prefs.setBool('isFirstTime', value);

  /// Checks if the user has completed the onboarding flow.
  /// Default: `false`
  bool get isOnboardingCompleted => _prefs.getBool('isOnboardingCompleted') ?? false;

  /// Updates the onboarding completed status.
  Future<bool> setIsOnboardingCompleted(bool value) => _prefs.setBool('isOnboardingCompleted', value);

  /// Checks if the user authentication is completed.
  /// Default: `false`
  bool get isAuthCompleted => _prefs.getBool('isAuthCompleted') ?? false;

  /// Updates the authentication completed status.
  Future<bool> setIsAuthCompleted(bool value) => _prefs.setBool('isAuthCompleted', value);

  /// Checks if the user is on a premium/subscription plan.
  /// Default: `false`
  bool get isSubscribed => _prefs.getBool('isSubscribed') ?? false;

  /// Updates the subscription status.
  Future<bool> setIsSubscribed(bool value) => _prefs.setBool('isSubscribed', value);

  /// Clears all preferences.
  Future<bool> clear() => _prefs.clear();
}

