import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:catalyst/l10n/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../view_model/onboarding_view_model.dart';

class DemographicsStep extends ConsumerStatefulWidget {
  final Function(bool isPaused) onFocusChange;
  final VoidCallback onValidationSuccess;

  const DemographicsStep({
    super.key,
    required this.onFocusChange,
    required this.onValidationSuccess,
  });

  @override
  ConsumerState<DemographicsStep> createState() => _DemographicsStepState();
}

class _DemographicsStepState extends ConsumerState<DemographicsStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _disciplineController = TextEditingController();
  final _uniController = TextEditingController();

  final List<FocusNode> _focusNodes = List.generate(3, (_) => FocusNode());

  final List<String> _disciplines = [
    'Software Engineering',
    'Data Science & Analytics',
    'Product Management',
    'Cybersecurity',
    'UI/UX Design',
    'Cloud & DevOps Engineering',
  ];

  final List<String> _universities = [
    'University of New South Wales (UNSW)',
    'University of Sydney (USYD)',
    'University of Technology Sydney (UTS)',
    'Macquarie University',
    'Western Sydney University (WSU)',
    'Other Australian Institution',
  ];

  final List<String> _visaOptions = [
    'PR / Citizen (Permanent Resident / Citizen)',
    'Subclass 485 (Temporary Graduate Visa)',
    'Subclass 500 (Student Visa)',
  ];

  String _selectedVisa = 'PR / Citizen (Permanent Resident / Citizen)';

  @override
  void initState() {
    super.initState();
    // Load existing state from ViewModel
    final onboardingState = ref.read(onboardingViewModelProvider);
    _nameController.text = onboardingState.fullName;
    _disciplineController.text = onboardingState.targetDiscipline;
    _uniController.text = onboardingState.educationProvider;
    if (onboardingState.visaSubclass.isNotEmpty) {
      final matched = _visaOptions.firstWhere(
        (opt) => opt.contains(onboardingState.visaSubclass),
        orElse: () => _visaOptions.first,
      );
      _selectedVisa = matched;
    }

    // Attach focus listeners to pause the progress story timer if desired
    for (var focusNode in _focusNodes) {
      focusNode.addListener(() {
        final anyFocused = _focusNodes.any((node) => node.hasFocus);
        widget.onFocusChange(anyFocused);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _disciplineController.dispose();
    _uniController.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(onboardingViewModelProvider.notifier);
      notifier.setFullName(_nameController.text.trim());
      notifier.setTargetDiscipline(_disciplineController.text.trim());
      notifier.setEducationProvider(_uniController.text.trim());
      
      String visaCode = 'PR';
      if (_selectedVisa.contains('485')) {
        visaCode = '485';
      } else if (_selectedVisa.contains('500')) {
        visaCode = '500';
      }
      notifier.setVisaSubclass(visaCode);
      
      FocusScope.of(context).unfocus();
      widget.onValidationSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                Text(
                  l10n.demographicsTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.demographicsSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  focusNode: _focusNodes[0],
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.fullName,
                    prefixIcon: const Icon(LucideIcons.user),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusLg)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.pleaseEnterName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Target Discipline Autocomplete
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return _disciplines;
                    }
                    return _disciplines.where((String option) {
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    if (_disciplineController.text.isNotEmpty && controller.text.isEmpty) {
                      controller.text = _disciplineController.text;
                    }
                    focusNode.addListener(() {
                      _focusNodes[1].requestFocus();
                    });
                    
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: l10n.targetDiscipline,
                        prefixIcon: const Icon(LucideIcons.briefcase),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusLg)),
                        suffixIcon: const Icon(LucideIcons.chevronDown, size: 18),
                      ),
                      onChanged: (val) => _disciplineController.text = val,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.pleaseEnterDiscipline;
                        }
                        return null;
                      },
                    );
                  },
                  onSelected: (String selection) {
                    _disciplineController.text = selection;
                  },
                ),
                const SizedBox(height: 18),

                // Uni Autocomplete
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return _universities;
                    }
                    return _universities.where((String option) {
                      return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    if (_uniController.text.isNotEmpty && controller.text.isEmpty) {
                      controller.text = _uniController.text;
                    }
                    focusNode.addListener(() {
                      _focusNodes[2].requestFocus();
                    });

                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: l10n.educationProvider,
                        prefixIcon: const Icon(LucideIcons.graduationCap),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusLg)),
                        suffixIcon: const Icon(LucideIcons.chevronDown, size: 18),
                      ),
                      onChanged: (val) => _uniController.text = val,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.pleaseEnterProvider;
                        }
                        return null;
                      },
                    );
                  },
                  onSelected: (String selection) {
                    _uniController.text = selection;
                  },
                ),
                const SizedBox(height: 18),

                // Visa Status Constraint Dropdown
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: _selectedVisa,
                  decoration: InputDecoration(
                    labelText: l10n.visaSubclassLabel,
                    prefixIcon: const Icon(LucideIcons.landmark),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTokens.radiusLg)),
                  ),
                  items: _visaOptions.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedVisa = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 32),

                // Next Button
                ElevatedButton(
                  onPressed: _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTokens.radiusLg)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.nextStep,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(width: 8),
                      const Icon(LucideIcons.arrowRight, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
