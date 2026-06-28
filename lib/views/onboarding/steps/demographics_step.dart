import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../models/onboarding_state.dart';

class DemographicsStep extends StatefulWidget {
  final OnboardingState state;
  final Function(bool isPaused) onFocusChange;
  final VoidCallback onValidationSuccess;

  const DemographicsStep({
    super.key,
    required this.state,
    required this.onFocusChange,
    required this.onValidationSuccess,
  });

  @override
  State<DemographicsStep> createState() => _DemographicsStepState();
}

class _DemographicsStepState extends State<DemographicsStep> {
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
    // Load existing state if any
    _nameController.text = widget.state.fullName;
    _disciplineController.text = widget.state.targetDiscipline;
    _uniController.text = widget.state.educationProvider;
    if (widget.state.visaSubclass.isNotEmpty) {
      // Find matching item
      final matched = _visaOptions.firstWhere(
        (opt) => opt.contains(widget.state.visaSubclass),
        orElse: () => _visaOptions.first,
      );
      _selectedVisa = matched;
    }

    // Attach focus listeners to pause the auto-advance story timer
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
      widget.state.setFullName(_nameController.text.trim());
      widget.state.setTargetDiscipline(_disciplineController.text.trim());
      widget.state.setEducationProvider(_uniController.text.trim());
      
      // Extract code like "485" or "500" or "PR"
      String visaCode = 'PR';
      if (_selectedVisa.contains('485')) {
        visaCode = '485';
      } else if (_selectedVisa.contains('500')) {
        visaCode = '500';
      }
      widget.state.setVisaSubclass(visaCode);
      
      // Dismiss keyboard and focus
      FocusScope.of(context).unfocus();
      widget.onValidationSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  "Tell Us About Yourself",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "We use this to customize recommendations for the Sydney job market.",
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
                    labelText: "Full Name",
                    prefixIcon: const Icon(LucideIcons.user),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),

                // Target Discipline Autocomplete/Dropdown
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
                    // Sync controllers if field initialized
                    if (_disciplineController.text.isNotEmpty && controller.text.isEmpty) {
                      controller.text = _disciplineController.text;
                    }
                    // Sync focus node with our list to track focus properly
                    focusNode.addListener(() {
                      _focusNodes[1].requestFocus();
                    });
                    
                    return TextFormField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: "Target Discipline / Role",
                        prefixIcon: const Icon(LucideIcons.briefcase),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: const Icon(LucideIcons.chevronDown, size: 18),
                      ),
                      onChanged: (val) => _disciplineController.text = val,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please select or type your target discipline";
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

                // Uni Autocomplete/Dropdown
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
                        labelText: "Education Provider",
                        prefixIcon: const Icon(LucideIcons.graduationCap),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: const Icon(LucideIcons.chevronDown, size: 18),
                      ),
                      onChanged: (val) => _uniController.text = val,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please select or type your university";
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
                  initialValue: _selectedVisa,
                  decoration: InputDecoration(
                    labelText: "Australian Visa Subclass / Status",
                    prefixIcon: const Icon(LucideIcons.landmark),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      Icon(LucideIcons.arrowRight, size: 18),
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
