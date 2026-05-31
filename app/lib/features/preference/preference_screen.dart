import 'package:app/widgets/refresh_drag_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/core/theme/app_color.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/core/services/refresh_service.dart';
import 'package:app/core/services/storage_service.dart';
import 'package:app/features/preference/widgets/animated_option_button.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  String _language = 'EN';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await StorageService.getLanguage();
    if (mounted) setState(() => _language = lang);
  }

  Future<void> _setLanguage(String lang) async {
    setState(() => _language = lang);
    await StorageService.setLanguage(lang);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;
    final dimColor = isDark ? Colors.white54 : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Preferences'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshDragPopWidget(
        onRefresh: () => RefreshService.refreshPreferences(context),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Theme ───────────────────────────────────────────
                const SizedBox(height: 6),
                _ThemeCard(
                  themeMode: themeController.themeMode,
                  onSurface: onSurface,
                  dimColor: dimColor,
                  onThemeChanged: (mode) => themeController.setThemeMode(mode),
                ),

                const SizedBox(height: 24),

                // ── Language ────────────────────────────────────────
                const SizedBox(height: 6),
                _LanguageCard(
                  language: _language,
                  onSurface: onSurface,
                  dimColor: dimColor,
                  onLanguageChanged: _setLanguage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Language Card ───────────────────────────────────────────────────────────

class _LanguageCard extends StatelessWidget {
  final String language;
  final Color onSurface;
  final Color dimColor;
  final ValueChanged<String> onLanguageChanged;

  const _LanguageCard({
    required this.language,
    required this.onSurface,
    required this.dimColor,
    required this.onLanguageChanged,
  });

  String _languageName(String code) {
    return switch (code) {
      'EN' => 'English',
      'KH' => 'ភាសាខ្មែរ',
      _ => 'English',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.translate_rounded, color: dimColor, size: 22),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Language',
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _languageName(language),
                      style: TextStyle(
                        color: dimColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 375),
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: AnimatedOptionButton<String>(
                        value: 'EN',
                        selectedValue: language,
                        icon: null,
                        label: 'EN',
                        onTap: () => onLanguageChanged('EN'),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 375),
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: AnimatedOptionButton<String>(
                        value: 'KH',
                        selectedValue: language,
                        icon: null,
                        label: 'KH',
                        onTap: () => onLanguageChanged('KH'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Theme Card ──────────────────────────────────────────────────────────────

class _ThemeCard extends StatelessWidget {
  final ThemeMode themeMode;
  final Color onSurface;
  final Color dimColor;
  final ValueChanged<ThemeMode> onThemeChanged;

  const _ThemeCard({
    required this.themeMode,
    required this.onSurface,
    required this.dimColor,
    required this.onThemeChanged,
  });

  String _label(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => 'Auto',
      ThemeMode.light => 'Light',
      ThemeMode.dark => 'Dark',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette_rounded, color: dimColor, size: 22),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme Mode',
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _label(themeMode),
                      style: TextStyle(
                        color: dimColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 375),
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: AnimatedOptionButton<ThemeMode>(
                        value: ThemeMode.system,
                        selectedValue: themeMode,
                        icon: Icons.phone_android_rounded,
                        label: 'Auto',
                        onTap: () => onThemeChanged(ThemeMode.system),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 375),
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: AnimatedOptionButton<ThemeMode>(
                        value: ThemeMode.light,
                        selectedValue: themeMode,
                        icon: Icons.light_mode_rounded,
                        label: 'Light',
                        onTap: () => onThemeChanged(ThemeMode.light),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AnimationConfiguration.staggeredList(
                    position: 2,
                    duration: const Duration(milliseconds: 375),
                    child: ScaleAnimation(
                      scale: 0.5,
                      child: AnimatedOptionButton<ThemeMode>(
                        value: ThemeMode.dark,
                        selectedValue: themeMode,
                        icon: Icons.dark_mode_rounded,
                        label: 'Dark',
                        onTap: () => onThemeChanged(ThemeMode.dark),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
