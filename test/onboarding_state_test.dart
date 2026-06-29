import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catalyst/features/onboarding/view_model/onboarding_view_model.dart';

void main() {
  group('OnboardingNotifier MVVM Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial values are empty/default', () {
      final state = container.read(onboardingViewModelProvider);
      expect(state.fullName, isEmpty);
      expect(state.targetDiscipline, isEmpty);
      expect(state.educationProvider, isEmpty);
      expect(state.visaSubclass, 'PR/Citizen');
      expect(state.resumePath, isNull);
      expect(state.resumeText, isNull);
      expect(state.processingProgress, 0.0);
      expect(state.processingStage, isEmpty);
      expect(state.aiAnalysisReport, isNull);
    });

    test('Updating demographics updates the state', () {
      final notifier = container.read(onboardingViewModelProvider.notifier);
      
      notifier.setFullName('Jane Doe');
      expect(container.read(onboardingViewModelProvider).fullName, 'Jane Doe');

      notifier.setTargetDiscipline('Cybersecurity');
      expect(container.read(onboardingViewModelProvider).targetDiscipline, 'Cybersecurity');

      notifier.setEducationProvider('USYD');
      expect(container.read(onboardingViewModelProvider).educationProvider, 'USYD');

      notifier.setVisaSubclass('485');
      expect(container.read(onboardingViewModelProvider).visaSubclass, '485');
    });

    test('Setting resume updates values', () {
      final notifier = container.read(onboardingViewModelProvider.notifier);

      notifier.setResume('/path/to/resume.pdf', 'My Resume Text');
      final state = container.read(onboardingViewModelProvider);
      expect(state.resumePath, '/path/to/resume.pdf');
      expect(state.resumeText, 'My Resume Text');
    });

    test('Updating processing stage updates values', () {
      final notifier = container.read(onboardingViewModelProvider.notifier);

      notifier.updateProcessing(0.5, 'Thinking...');
      final state = container.read(onboardingViewModelProvider);
      expect(state.processingProgress, 0.5);
      expect(state.processingStage, 'Thinking...');
    });

    test('Setting AI report updates values', () {
      final notifier = container.read(onboardingViewModelProvider.notifier);

      notifier.setAiAnalysisReport('Gemma Analysis');
      final state = container.read(onboardingViewModelProvider);
      expect(state.aiAnalysisReport, 'Gemma Analysis');
    });
  });
}
