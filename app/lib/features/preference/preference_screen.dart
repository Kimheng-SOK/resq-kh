import 'package:app/features/preference/language/language_widget.dart';
import 'package:app/widgets/refresh_drag_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:app/core/theme/app_color.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/core/services/refresh_service.dart';
import 'package:app/core/services/storage_service.dart';
import 'package:app/features/preference/theme/theme_widget.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _setLanguage(String lang) async {
    setState(() => _language = lang);
    await StorageService.setLanguage(lang);
  }

  Future<void> _loadLanguage() async {
    final lang = await StorageService.getLanguage();
    if (mounted) setState(() => _language = lang);
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
        onRefresh: () async {
          await RefreshService.refreshPreferences(context);
          await _loadLanguage();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          child: AnimationLimiter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Theme ───────────────────────────────────────────
                const SizedBox(height: 6),
                ThemeCard(
                  themeMode: themeController.themeMode,
                  onSurface: onSurface,
                  dimColor: dimColor,
                  onThemeChanged: (mode) => themeController.setThemeMode(mode),
                ),

                const SizedBox(height: 24),

                // ── Language ────────────────────────────────────────
                const SizedBox(height: 6),
                LanguageCard(
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
