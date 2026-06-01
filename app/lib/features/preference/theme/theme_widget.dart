// ─── Theme Card ──────────────────────────────────────────────────────────────
import 'package:app/features/preference/widgets/animated_option_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
