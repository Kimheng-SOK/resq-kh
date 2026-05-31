import 'package:app/features/home/widgets/location_chip.dart';
import 'package:app/features/home/widgets/quick_action_tile.dart';
import 'package:app/features/home/widgets/sos_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dimText = theme.textTheme.bodyMedium!.color!;

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LocationChip(location: 'Phnom Penh'),
                  GestureDetector(
                    onTap: () => context.push('/settings'),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black54 : AppColors.shadow,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.settings_rounded,
                        color: dimText,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),

              // --- Pulsing SOS Button ---
              const SizedBox(height: 32),
              SOSButton(onTap: () => _showSOSDialog(context)),
              const SizedBox(height: 8),
              Text(
                'Tap for emergency help',
                style: TextStyle(
                  color: dimText,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Quick Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: dimText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),
              QuickActionTile(
                label: 'Police',
                icon: Icons.local_police_rounded,
                color: AppColors.police,
                onTap: () => context.push('/services/police'),
              ),
              const SizedBox(height: 10),
              QuickActionTile(
                label: 'Hospital',
                icon: Icons.local_hospital_rounded,
                color: AppColors.hospital,
                onTap: () => context.push('/services/hospital'),
              ),
              const SizedBox(height: 10),
              QuickActionTile(
                label: 'Fire',
                icon: Icons.local_fire_department_rounded,
                color: AppColors.fire,
                onTap: () => context.push('/services/fire'),
              ),
              const SizedBox(height: 10),
              QuickActionTile(
                label: 'Ambulance',
                icon: Icons.airport_shuttle_rounded,
                color: AppColors.ambulance,
                onTap: () => context.push('/services/ambulance'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showSOSDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.red, size: 28),
            SizedBox(width: 10),
            Text(
              'EMERGENCY',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        content: const Text(
          'This will immediately call the national emergency hotline.\n\nAre you sure you need emergency help?',
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              minimumSize: const Size(120, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.push('/sos');
            },
            child: const Text(
              'CALL 119',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
