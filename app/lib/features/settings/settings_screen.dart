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
  String _bloodGroup = '';
  bool _loading = true;
  final _allergiesController = TextEditingController();

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _loadSettings();
  // }

  @override
  void dispose() {
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final dimColor = theme.textTheme.bodyMedium?.color!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.red))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(title: 'Language', color: dimColor),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
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
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              ButtonSegment(
                                value: 'KH',
                                label: Text(
                                  'KH',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                            selected: {_language},
                            onSelectionChanged: (value) {
                              setState(() => _language = value.first);
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.resolveWith((
                                state,
                              ) {
                                if (state.contains(WidgetState.selected)) {
                                  return AppColors.red;
                                }
                                return Colors.transparent;
                              }),
                              foregroundColor: WidgetStateProperty.resolveWith((
                                state,
                              ) {
                                if (state.contains(WidgetState.selected)) {
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

                  const SizedBox(height: 24),

                  // Dark Mode
                  SectionHeader(title: 'Appearance', color: dimColor),
                  const SizedBox(height: 8),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
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
                                label: Text('System'),
                              ),
                              ButtonSegment(
                                value: ThemeMode.light,
                                label: Text('Light'),
                              ),
                              ButtonSegment(
                                value: ThemeMode.dark,
                                label: Text('Dark'),
                              ),
                            ],
                            selected: {themeController.themeMode},
                            onSelectionChanged: (value) {
                              themeController.setThemeMode(value.first);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
