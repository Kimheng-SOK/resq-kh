// ─── Theme Card ──────────────────────────────────────────────────────────────
import 'package:app/features/preference/widgets/animated_option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:app/core/l10n/app_localizations.dart';

class ThemeCard extends StatelessWidget {
  final ThemeMode themeMode;
  final Color onSurface;
  final Color dimColor;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ThemeCard({
    super.key,
    required this.themeMode,
    required this.onSurface,
    required this.dimColor,
    required this.onThemeChanged,
  });

  String _label(ThemeMode mode, AppLocalizations l10n) {
    return switch (mode) {
      ThemeMode.system => l10n.themeAuto,
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                      l10n.themeMode,
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _label(themeMode, l10n),
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
                        label: l10n.themeAuto,
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
                        label: l10n.themeLight,
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
                        label: l10n.themeDark,
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
