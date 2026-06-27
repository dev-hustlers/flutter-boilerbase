import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_boilerbase/services/preferences_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PreferencesService Tests', () {
    late PreferencesService preferencesService;

    setUp(() async {
      // Mock the initial values of SharedPreferences to be empty
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      preferencesService = PreferencesService(prefs);
    });

    test('Default values are correct', () {
      // isFirstTime should default to true so first-launch flows are triggered
      expect(preferencesService.isFirstTime, isTrue);
      
      // Other flags should default to false
      expect(preferencesService.isOnboardingCompleted, isFalse);
      expect(preferencesService.isAuthCompleted, isFalse);
      expect(preferencesService.isSubscribed, isFalse);
    });

    test('Updating preferences sets values correctly', () async {
      await preferencesService.setIsFirstTime(false);
      expect(preferencesService.isFirstTime, isFalse);

      await preferencesService.setIsOnboardingCompleted(true);
      expect(preferencesService.isOnboardingCompleted, isTrue);

      await preferencesService.setIsAuthCompleted(true);
      expect(preferencesService.isAuthCompleted, isTrue);

      await preferencesService.setIsSubscribed(true);
      expect(preferencesService.isSubscribed, isTrue);
    });

    test('Clearing preferences resets values to defaults', () async {
      await preferencesService.setIsFirstTime(false);
      await preferencesService.setIsOnboardingCompleted(true);
      await preferencesService.setIsAuthCompleted(true);
      await preferencesService.setIsSubscribed(true);

      await preferencesService.clear();

      expect(preferencesService.isFirstTime, isTrue);
      expect(preferencesService.isOnboardingCompleted, isFalse);
      expect(preferencesService.isAuthCompleted, isFalse);
      expect(preferencesService.isSubscribed, isFalse);
    });
  });
}
