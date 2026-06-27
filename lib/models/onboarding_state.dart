import 'package:flutter/material.dart';

/// Manage state during the onboarding flow.
class OnboardingState extends ChangeNotifier {
  String _fullName = '';
  String _targetDiscipline = '';
  String _educationProvider = '';
  String _visaSubclass = 'PR/Citizen'; // Default to PR/Citizen
  String? _resumePath;
  String? _resumeText;
  String? _aiAnalysisReport;
  bool _isProcessing = false;
  double _processingProgress = 0.0;
  String _processingStage = '';

  // Getters
  String get fullName => _fullName;
  String get targetDiscipline => _targetDiscipline;
  String get educationProvider => _educationProvider;
  String get visaSubclass => _visaSubclass;
  String? get resumePath => _resumePath;
  String? get resumeText => _resumeText;
  String? get aiAnalysisReport => _aiAnalysisReport;
  bool get isProcessing => _isProcessing;
  double get processingProgress => _processingProgress;
  String get processingStage => _processingStage;

  // Setters with notifyListeners
  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setTargetDiscipline(String value) {
    _targetDiscipline = value;
    notifyListeners();
  }

  void setEducationProvider(String value) {
    _educationProvider = value;
    notifyListeners();
  }

  void setVisaSubclass(String value) {
    _visaSubclass = value;
    notifyListeners();
  }

  void setResume(String path, String text) {
    _resumePath = path;
    _resumeText = text;
    notifyListeners();
  }

  void setAiAnalysisReport(String? value) {
    _aiAnalysisReport = value;
    notifyListeners();
  }

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  void updateProcessing(double progress, String stage) {
    _processingProgress = progress;
    _processingStage = stage;
    notifyListeners();
  }

  void reset() {
    _fullName = '';
    _targetDiscipline = '';
    _educationProvider = '';
    _visaSubclass = 'PR/Citizen';
    _resumePath = null;
    _resumeText = null;
    _aiAnalysisReport = null;
    _isProcessing = false;
    _processingProgress = 0.0;
    _processingStage = '';
    notifyListeners();
  }
}
