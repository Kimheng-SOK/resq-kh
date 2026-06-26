import 'package:app/providers/radius_provider.dart';
import 'package:app/services/location_preferences_service.dart';
import 'package:app/services/refresh_service.dart';
import 'package:app/core/theme/app_color.dart';
import 'package:app/features/settings/widgets/delete_modal_sheet.dart';
import 'package:app/features/settings/widgets/section_header_widget.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/widgets/refresh_drag_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widgets/setting_tile_widget.dart';
import 'widgets/diver_widget.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;

  Future<void> _handleDeleteAccount() async {
    // Use the actual user's name for the confirmation message
    final userState = ref.read(userProvider);
    final userName = userState.user?.fullName ?? 'USER';

    final confirmed = await showDeleteAccountSheet(
      context,
      confirmMessage: userName,
    );

    if (confirmed == true && mounted) {
      context.go('/register');
    }
  }

  Future<void> _showRadiusDialog(BuildContext context) async {
    double selectedRadius = await LocationPreferencesService.getRadius();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Nearby Search Radius'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${selectedRadius.toStringAsFixed(1)} km'),

                  Slider(
                    value: selectedRadius,
                    min: 0.5,
                    max: 20,
                    divisions: 39,
                    label: '${selectedRadius.toStringAsFixed(1)} km',
                    onChanged: (value) {
                      setState(() {
                        selectedRadius = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await LocationPreferencesService.saveRadius(selectedRadius);

                ref.read(radiusProvider.notifier).state = selectedRadius;

                Navigator.pop(ctx);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRadius();
  }

  Future<void> _loadRadius() async {
    final radius = await LocationPreferencesService.getRadius();

    ref.read(radiusProvider.notifier).state = radius;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dimColor = isDark ? Colors.white54 : AppColors.textSecondary;

    final List<Map<String, dynamic>> profileItems = [
      {
        'icon': Icons.person_outline_rounded,
        'label': 'Edit Profile',
        'route': '/profile',
      },
      {
        'icon': Icons.settings_outlined,
        'label': 'Preferences',
        'route': '/preferences',
      },
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshDragPopWidget(
        onRefresh: () => RefreshService.refreshSettings(context),
        child: SingleChildScrollView(
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
                    // SettingsTile(
                    //   icon: Icons.person_outline_rounded,
                    //   label: 'Edit Profile',
                    //   onTap: () => context.push('/profile'),
                    // ),
                    // const DividerWidget(),
                    // SettingsTile(
                    //   icon: Icons.lock_outline_rounded,
                    //   label: 'Change Password',
                    //   onTap: () {},
                    // ),
                    // const DividerWidget(),
                    // SettingsTile(
                    //   icon: Icons.settings_outlined,
                    //   label: 'Preferences',
                    //   onTap: () => context.push('/preferences'),
                    // ),
                    for (int i = 0; i < profileItems.length; i++) ...[
                      SettingsTile(
                        icon: profileItems[i]['icon'],
                        label: profileItems[i]['label'],
                        onTap: profileItems[i]['route'] != null
                            ? () => context.push(profileItems[i]['route'])
                            : null,
                      ),
                      if (i < profileItems.length - 1) const DividerWidget(),
                    ],
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
                    SettingsTile(
                      icon: Icons.notifications_outlined,
                      label: 'Push Notifications',
                      trailing: Switch(
                        value: _pushNotifications,
                        activeTrackColor: AppColors.red,
                        onChanged: (v) =>
                            setState(() => _pushNotifications = v),
                      ),
                    ),
                    const DividerWidget(),
                    SettingsTile(
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

              // ── Account ──────────────────────────────────────────
              SectionHeader(title: 'Account', color: dimColor),
              const SizedBox(height: 6),
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.medical_information_outlined,
                      label: 'Medical Info',
                      onTap: () => context.push(
                        '/complete-profile',
                        extra: {'editing': true},
                      ),
                    ),
                    // const DividerWidget(),
                    // SettingsTile(
                    //   icon: Icons.contacts_outlined,
                    //   label: 'Emergency Contacts',
                    //   onTap: () {},
                    // ),
                    const DividerWidget(),
                    SettingsTile(
                      icon: Icons.location_searching_rounded,
                      label: 'Nearby Search Radius',
                      onTap: () => _showRadiusDialog(context),
                    ),
                    const DividerWidget(),
                    SettingsTile(
                      icon: Icons.location_on_outlined,
                      label: 'Location Permission',
                      onTap: () async {
                        await openAppSettings();
                      },
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
                    SettingsTile(
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
                    const DividerWidget(),
                    SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      onTap: () {},
                    ),
                    const DividerWidget(),
                    SettingsTile(
                      icon: Icons.article_outlined,
                      label: 'Terms of Service',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              Material(
                color: isDark ? AppColors.redDark : AppColors.red,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: _handleDeleteAccount,
                  borderRadius: BorderRadius.circular(12),
                  hoverColor: Colors.white.withValues(alpha: 0.15),
                  splashColor: Colors.white.withValues(alpha: 0.25),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Delete Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
