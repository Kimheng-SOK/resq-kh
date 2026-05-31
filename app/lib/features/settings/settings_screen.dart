import 'package:app/core/theme/app_color.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:app/features/settings/widgets/section_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'EN';
  bool _pushNotifications = true;
  bool _emailAlerts = false;

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
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile ──────────────────────────────────────────
            SectionHeader(title: 'Profile', color: dimColor),
            const SizedBox(height: 6),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.person_outline_rounded,
                    label: 'Edit Profile',
                    onTap: () => context.push('/profile'),
                  ),
                  _Divider(),
                  _SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Change Password',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Notifications ────────────────────────────────────
            SectionHeader(title: 'Notifications', color: dimColor),
            const SizedBox(height: 6),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    label: 'Push Notifications',
                    trailing: Switch(
                      value: _pushNotifications,
                      activeTrackColor: AppColors.red,
                      onChanged: (v) =>
                          setState(() => _pushNotifications = v),
                    ),
                  ),
                  _Divider(),
                  _SettingsTile(
                    icon: Icons.email_outlined,
                    label: 'Email Alerts',
                    trailing: Switch(
                      value: _emailAlerts,
                      activeTrackColor: AppColors.red,
                      onChanged: (v) => setState(() => _emailAlerts = v),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Preferences ──────────────────────────────────────
            SectionHeader(title: 'Preferences', color: dimColor),
            const SizedBox(height: 6),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  // Language
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.language_rounded,
                          color: dimColor,
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'App Language',
                            style: TextStyle(
                              color: onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'EN',
                              label: Text(
                                'EN',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ButtonSegment(
                              value: 'KH',
                              label: Text(
                                'KH',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          selected: {_language},
                          onSelectionChanged: (value) {
                            setState(() => _language = value.first);
                          },
                          style: _segmentedButtonStyle(onSurface),
                        ),
                      ],
                    ),
                  ),

                  _Divider(),

                  // Theme Mode
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.dark_mode_rounded,
                          color: dimColor,
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Theme Mode',
                            style: TextStyle(
                              color: onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment(
                              value: ThemeMode.system,
                              label: Text(
                                'Auto',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              label: Text(
                                'Light',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              label: Text(
                                'Dark',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                          selected: {themeController.themeMode},
                          onSelectionChanged: (value) {
                            themeController.setThemeMode(value.first);
                          },
                          style: _segmentedButtonStyle(onSurface),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Account ──────────────────────────────────────────
            SectionHeader(title: 'Account', color: dimColor),
            const SizedBox(height: 6),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.medical_information_outlined,
                    label: 'Medical Info',
                    onTap: () {},
                  ),
                  _Divider(),
                  _SettingsTile(
                    icon: Icons.contacts_outlined,
                    label: 'Emergency Contacts',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── About ────────────────────────────────────────────
            SectionHeader(title: 'About', color: dimColor),
            const SizedBox(height: 6),
            Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    label: 'Version',
                    trailing: Text(
                      '1.0.0',
                      style: TextStyle(
                        color: dimColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  _Divider(),
                  _SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _Divider(),
                  _SettingsTile(
                    icon: Icons.article_outlined,
                    label: 'Terms of Service',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Logout ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text('Log Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  side: const BorderSide(color: AppColors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shared style for SegmentedButton used in Language and Theme rows.
  ButtonStyle _segmentedButtonStyle(Color onSurface) {
    return ButtonStyle(
      visualDensity: VisualDensity.compact,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: WidgetStateProperty.resolveWith((state) {
        if (state.contains(WidgetState.selected)) return AppColors.red;
        return Colors.transparent;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((state) {
        if (state.contains(WidgetState.selected)) return Colors.white;
        return onSurface;
      }),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Reusable settings tile
// ═══════════════════════════════════════════════════════════════════════

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: isDark ? Colors.white54 : AppColors.textSecondary, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white38 : AppColors.textSecondary.withAlpha(150),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

/// Thin divider matching the card's content inset.
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 52),
      child: Divider(height: 1, thickness: 0.5),
    );
  }
}
