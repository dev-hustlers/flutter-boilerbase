import 'package:flutter_test/flutter_test.dart';
import 'package:catalyst/main.dart';

void main() {
  group('OnboardingState Tests', () {
    late OnboardingState state;

    setUp(() {
      state = OnboardingState();
    });

    test('Initial values are empty/default', () {
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

    test('Updating demographics triggers notification', () {
      int notifications = 0;
      state.addListener(() {
        notifications++;
      });

      state.setFullName('Jane Doe');
      expect(state.fullName, 'Jane Doe');
      expect(notifications, 1);

      state.setTargetDiscipline('Cybersecurity');
      expect(state.targetDiscipline, 'Cybersecurity');
      expect(notifications, 2);

      state.setEducationProvider('USYD');
      expect(state.educationProvider, 'USYD');
      expect(notifications, 3);

      state.setVisaSubclass('485');
      expect(state.visaSubclass, '485');
      expect(notifications, 4);
    });

    test('Setting resume updates values and notifies', () {
      int notifications = 0;
      state.addListener(() {
        notifications++;
      });

      state.setResume('/path/to/resume.pdf', 'My Resume Text');
      expect(state.resumePath, '/path/to/resume.pdf');
      expect(state.resumeText, 'My Resume Text');
      expect(notifications, 1);
    });

    test('Updating processing stage updates values and notifies', () {
      int notifications = 0;
      state.addListener(() {
        notifications++;
      });

      state.updateProcessing(0.5, 'Thinking...');
      expect(state.processingProgress, 0.5);
      expect(state.processingStage, 'Thinking...');
      expect(notifications, 1);
    });

    test('Setting AI report updates values and notifies', () {
      int notifications = 0;
      state.addListener(() {
        notifications++;
      });

      state.setAiAnalysisReport('Gemma Analysis');
      expect(state.aiAnalysisReport, 'Gemma Analysis');
      expect(notifications, 1);
    });
  });
}
