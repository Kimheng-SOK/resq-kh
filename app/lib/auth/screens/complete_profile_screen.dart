import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/providers/user_provider.dart';

/// Screen for collecting/editing medical information.
///
/// Two modes:
/// - **Completion mode** (after signup, `editing: false`):
///   Auto-redirects to `/` if the profile is already complete.
/// - **Edit mode** (from settings, `editing: true`):
///   Always shows the form with a back button. Pops back on save.
class CompleteProfileScreen extends ConsumerStatefulWidget {
  final bool editing;

  const CompleteProfileScreen({super.key, this.editing = false});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  String? _bloodGroup;
  final _allergiesController = TextEditingController();
  final _medicalController = TextEditingController();
  bool _isChecking = true;

  static const _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      // Fetch the full user profile to check completion status
      final user = await ref.read(userProvider.notifier).fetchProfile();

      if (!mounted) return;

      if (user != null) {
        // Pre-fill existing data
        _bloodGroup = user.bloodType;
        _allergiesController.text = user.allergies ?? '';
        _medicalController.text = user.medicalConditions ?? '';

        // In completion mode, auto-skip if profile is already complete
        if (!widget.editing && user.isProfileComplete) {
          context.go('/');
          return;
        }
      }
    } catch (_) {
      // If anything fails, just show the form — don't leave the user stuck
    }

    if (mounted) {
      setState(() => _isChecking = false);
    }
  }

  Future<void> _saveAndContinue() async {
    // Only blood type is required — allergies and medical conditions are optional
    if (_bloodGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your blood type'),
        ),
      );
      return;
    }

    final allergiesText = _allergiesController.text.trim();

    final updated = await ref.read(userProvider.notifier).updateProfile(
      bloodGroup: _bloodGroup,
      allergies: allergiesText.isEmpty ? null : allergiesText,
      medicalConditions: _medicalController.text.trim().isEmpty
          ? null
          : _medicalController.text.trim(),
    );

    if (!mounted) return;

    if (updated != null) {
      if (widget.editing) {
        context.pop();
      } else {
        context.go('/');
      }
    } else {
      final error = ref.read(userProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to save profile. Please try again.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    _medicalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProvider).isLoading || _isChecking;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(widget.editing ? 'Edit Medical Info' : 'Complete Your Profile'),
        centerTitle: true,
        leading:
            widget.editing
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                    onPressed: () => context.pop(),
                  )
                : null,
      ),
      body: SafeArea(
        child:
            _isChecking
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),

                        const Icon(
                          Icons.medical_information_outlined,
                          size: 100,
                          color: Color(0xFFD32F2F),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          widget.editing
                              ? 'Update Medical Info'
                              : 'Medical Information',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'This information helps emergency responders\nprovide the right assistance quickly.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),

                        const SizedBox(height: 40),

                        // ── Blood Type ─────────────────────────────
                        DropdownButtonFormField<String>(
                          initialValue: _bloodGroup,
                          decoration: InputDecoration(
                            labelText: 'Blood Type *',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.bloodtype_outlined),
                          ),
                          items:
                              _bloodGroups.map((bg) {
                                return DropdownMenuItem(
                                  value: bg,
                                  child: Text(bg),
                                );
                              }).toList(),
                          onChanged: (v) =>
                              setState(() => _bloodGroup = v),
                        ),

                        const SizedBox(height: 20),

                        // ── Allergies ──────────────────────────────
                        TextField(
                          controller: _allergiesController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: 'Allergies (Optional)',
                            hintText: 'e.g., Penicillin, Peanuts, Latex',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.warning_amber_rounded),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Medical Conditions ─────────────────────
                        TextField(
                          controller: _medicalController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Medical Conditions (Optional)',
                            hintText:
                                'e.g., Asthma, Diabetes, Heart condition',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.note_alt_outlined),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // ── Save Button ────────────────────────────
                        SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _saveAndContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              disabledBackgroundColor: const Color(
                                0xFFD32F2F,
                              ).withAlpha(100),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child:
                                isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : Text(
                                        widget.editing
                                            ? 'Save Changes'
                                            : 'Save & Continue',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                          ),
                        ),

                        // ── Skip (completion mode only) ───────────
                        if (!widget.editing) ...[
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed:
                                isLoading ? null : () => context.go('/'),
                            child: const Text(
                              'Skip for now',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
      ),
    );
  }
}
