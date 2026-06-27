import 'package:app/core/l10n/app_localizations.dart';
import 'package:app/core/theme/app_color.dart';
import 'package:app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      final user = await ref.read(userProvider.notifier).fetchProfile();

      if (!mounted) return;

      if (user != null) {
        _bloodGroup = user.bloodType;
        _allergiesController.text = user.allergies ?? '';
        _medicalController.text = user.medicalConditions ?? '';

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
    if (_bloodGroup == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectBloodType)),
      );
      return;
    }

    final allergiesText = _allergiesController.text.trim();
    final medicalText = _medicalController.text.trim();

    final updated = await ref.read(userProvider.notifier).updateProfile(
      bloodGroup: _bloodGroup,
      allergies: allergiesText.isEmpty ? null : allergiesText,
      medicalConditions: medicalText.isEmpty ? null : medicalText,
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
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? l10n.failedToSaveProfile),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isLoading = ref.watch(userProvider).isLoading || _isChecking;
    final l10n = AppLocalizations.of(context)!;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: isDark ? Colors.white12 : AppColors.border),
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.editing ? l10n.editMedicalInfo : l10n.medicalInformation),
        centerTitle: true,
        leading: widget.editing
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: SafeArea(
        child: _isChecking
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Emergency Info Banner ──────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.redDark.withAlpha(40)
                            : const Color(0xFFFFF3F3),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isDark
                              ? AppColors.redDark.withAlpha(100)
                              : AppColors.red.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.red.withAlpha(isDark ? 40 : 20),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.medical_information_outlined,
                              color: AppColors.red,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.emergencyInfo,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: AppColors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.emergencyInfoDesc,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white54
                                        : AppColors.textSecondary,
                                    fontSize: 12,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Blood Type Card ────────────────────────────
                    _buildSectionHeader(
                      theme,
                      icon: Icons.bloodtype_outlined,
                      title: l10n.bloodType,
                      required: true,
                    ),
                    const SizedBox(height: 10),
                    Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _bloodGroups.map((bg) {
                            final selected = _bloodGroup == bg;
                            return GestureDetector(
                              onTap: () => setState(() => _bloodGroup = bg),
                              child: Container(
                                width: 68,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.red
                                      : isDark
                                          ? Colors.white.withValues(alpha: 0.06)
                                          : const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.red
                                        : isDark
                                            ? Colors.white12
                                            : AppColors.border,
                                    width: selected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    bg,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : isDark
                                              ? Colors.white70
                                              : AppColors.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Allergies Card ─────────────────────────────
                    _buildSectionHeader(
                      theme,
                      icon: Icons.warning_amber_rounded,
                      title: l10n.allergies,
                      required: false,
                    ),
                    const SizedBox(height: 10),
                    Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _allergiesController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: l10n.knownAllergies,
                            hintText: l10n.allergiesHint,
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.white24
                                  : AppColors.textSecondary.withAlpha(120),
                              fontSize: 14,
                            ),
                            border: inputBorder,
                            prefixIcon: const Icon(
                              Icons.warning_amber_rounded,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Medical Conditions Card ────────────────────
                    _buildSectionHeader(
                      theme,
                      icon: Icons.note_alt_outlined,
                      title: l10n.medicalConditions,
                      required: false,
                    ),
                    const SizedBox(height: 10),
                    Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _medicalController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: l10n.ongoingConditions,
                            hintText: l10n.conditionsHint,
                            hintStyle: TextStyle(
                              color: isDark
                                  ? Colors.white24
                                  : AppColors.textSecondary.withAlpha(120),
                              fontSize: 14,
                            ),
                            border: inputBorder,
                            prefixIcon: const Icon(
                              Icons.note_alt_outlined,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // ── Save Button ────────────────────────────────
                    SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _saveAndContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          disabledBackgroundColor:
                              AppColors.red.withAlpha(100),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                widget.editing ? l10n.saveChanges : l10n.saveAndContinue,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                      ),
                    ),

                    if (!widget.editing) ...[
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: isLoading ? null : () => context.go('/'),
                        child: Text(
                          l10n.skipForNow,
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required bool required,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.red),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          Text(
            l10n.requiredIndicator,
            style: const TextStyle(color: AppColors.red, fontSize: 16),
          ),
        ],
        const Spacer(),
        if (!required)
          Text(
            l10n.optional,
            style: TextStyle(
              color: AppColors.textSecondary.withAlpha(150),
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
