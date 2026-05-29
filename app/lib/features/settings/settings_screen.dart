import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_color.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'EN';
  String _bloodGroup = '';
  final _allergiesController = TextEditingController();
  bool _loading = true;

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final lang = await StorageService.getLanguage();
    final blood = await StorageService.getBloodGroup();
    final allergies = await StorageService.getAllergies();

    if (mounted) {
      setState(() {
        _language = lang;
        _bloodGroup = blood;
        _allergiesController.text = allergies;
        _loading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    await StorageService.setLanguage(_language);
    await StorageService.setBloodGroup(_bloodGroup);
    await StorageService.setAllergies(_allergiesController.text.trim());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final dimColor = theme.textTheme.bodyMedium!.color!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.red))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'Language', color: dimColor),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.language_rounded,
                              color: dimColor, size: 22),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text('App Language',
                                style: TextStyle(
                                    color: onSurface,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                          ),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                  value: 'EN',
                                  label: Text('EN',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                              ButtonSegment(
                                  value: 'KH',
                                  label: Text('KH',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600))),
                            ],
                            selected: {_language},
                            onSelectionChanged: (value) {
                              setState(() => _language = value.first);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppColors.red;
                                }
                                return Colors.transparent;
                              }),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Colors.white;
                                }
                                return onSurface;
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- Dark Mode ---
                  _SectionHeader(title: 'Appearance', color: dimColor),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            themeController.isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: dimColor,
                            size: 22,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dark Mode',
                                    style: TextStyle(
                                        color: onSurface,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                                Text('High contrast theme for low light',
                                    style: theme.textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          Switch(
                            value: themeController.isDark,
                            onChanged: (_) => themeController.toggle(),
                            activeTrackColor: AppColors.red,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- Medical Info ---
                  _SectionHeader(title: 'Medical Information', color: dimColor),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Blood Group',
                              style: TextStyle(
                                  color: onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            initialValue:
                                _bloodGroup.isNotEmpty ? _bloodGroup : null,
                            decoration: const InputDecoration(
                              hintText: 'Select blood group',
                            ),
                            items: _bloodGroups
                                .map((bg) => DropdownMenuItem(
                                    value: bg, child: Text(bg)))
                                .toList(),
                            onChanged: (val) {
                              setState(() => _bloodGroup = val ?? '');
                            },
                          ),
                          const SizedBox(height: 16),
                          Text('Allergies',
                              style: TextStyle(
                                  color: onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _allergiesController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              hintText: 'e.g. Penicillin, Peanuts, Latex',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      child: const Text('Save Settings',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(title,
          style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5)),
    );
  }
}
