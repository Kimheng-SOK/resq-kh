import 'dart:math';

import 'package:app/core/utils/launcher_helper.dart';
import 'package:app/features/home/widgets/location_chip.dart';
import 'package:app/features/home/widgets/quick_action_tile.dart';
import 'package:app/features/home/widgets/sos_button.dart';
import 'package:app/models/contact_model.dart';
import 'package:app/services/contact_service.dart';
import 'package:app/services/emergency_repository.dart';
import 'package:app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_color.dart';
import 'widgets/emergency_radial_menu.dart';
import 'widgets/hold_to_activate_sos.dart';
import 'package:app/core/utils/emergency_menu_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _loadingCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dimText = theme.textTheme.bodyMedium!.color!;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LocationChip(location: 'Phnom Penh'),
                GestureDetector(
                  onTap: () => context.push('/preferences'),
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

            const SizedBox(height: 32),
            // SOSButton(onTap: () => _showSOSDialog(context)),
            HoldToActivateSOS(
              onTap: () => _showSOSDialog(context),    
              onHoldComplete: () => showEmergencyRadialMenu(context),
            ),
            const SizedBox(height: 16),
            Text(
              'Tap for emergency help or hold to report an incident',
              style: TextStyle(
                color: dimText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 26),
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Quick Actions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: dimText,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.08,
                  children: [
                    QuickActionTile(
                      label: 'Police Station',
                      icon: Icons.local_police_rounded,
                      color: AppColors.police,
                      isLoading: _loadingCategory == 'police',
                      onTap: () => _handleServiceTap(
                        context,
                        'police',
                        'Police Station',
                      ),
                    ),
                    QuickActionTile(
                      label: 'Hospital',
                      icon: Icons.local_hospital_rounded,
                      color: AppColors.hospital,
                      isLoading: _loadingCategory == 'hospital',
                      onTap: () =>
                          _handleServiceTap(context, 'hospital', 'Hospital'),
                    ),
                    QuickActionTile(
                      label: 'Fire Station',
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.fire,
                      isLoading: _loadingCategory == 'fire',
                      onTap: () =>
                          _handleServiceTap(context, 'fire', 'Fire Station'),
                    ),
                    QuickActionTile(
                      label: 'Ambulance',
                      icon: Icons.airport_shuttle_rounded,
                      color: AppColors.ambulance,
                      isLoading: _loadingCategory == 'ambulance',
                      onTap: () =>
                          _handleServiceTap(context, 'ambulance', 'Ambulance'),
                    ),
                    QuickActionTile(
                      label: 'Contact',
                      icon: Icons.contacts_rounded,
                      color: AppColors.red,
                      isLoading: _loadingCategory == 'contact',
                      onTap: () => _handleGeneralContactTap(context),
                    ),
                    QuickActionTile(
                      label: 'Nearby',
                      icon: Icons.map_rounded,
                      color: Colors.teal,
                      isLoading: false,
                      onTap: () => context.push('/contacts/nearby'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleServiceTap(
    BuildContext context,
    String category,
    String label,
  ) async {
    if (_loadingCategory != null) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _loadingCategory = category;
    });

    try {
      final contacts = await EmergencyRepository().getByType(category);
      if (contacts.isEmpty) {
        _showMessage(messenger, 'No $label entries are available right now.');
        return;
      }

      final position = await LocationService.getCurrentLocation();
      final selected = position == null
          ? contacts.first
          : contacts.reduce((best, current) {
              final bestDistance = _distanceKm(
                position.latitude,
                position.longitude,
                best.lat,
                best.lng,
              );
              final currentDistance = _distanceKm(
                position.latitude,
                position.longitude,
                current.lat,
                current.lng,
              );
              return currentDistance < bestDistance ? current : best;
            });

      if (selected.phone.trim().isEmpty) {
        _showMessage(
          messenger,
          'This service does not have a phone number yet.',
        );
        return;
      }

      await LauncherHelper.makeCall(selected.phone);
    } catch (_) {
      _showMessage(messenger, 'Unable to place the call right now.');
    } finally {
      if (mounted) {
        setState(() {
          _loadingCategory = null;
        });
      }
    }
  }

  Future<void> _handleGeneralContactTap(BuildContext context) async {
    if (_loadingCategory != null) return;

    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _loadingCategory = 'contact';
    });

    try {
      final payload = await ContactService.getContacts();
      final contacts = payload
          .map((item) => Contact.fromJson(item as Map<String, dynamic>))
          .toList();

      if (contacts.isEmpty) {
        _showMessage(messenger, 'No general contacts have been saved yet.');
        return;
      }

      final firstContact = contacts.first;
      if (firstContact.phoneNumber.trim().isEmpty) {
        _showMessage(
          messenger,
          'The selected contact does not have a phone number.',
        );
        return;
      }

      await LauncherHelper.makeCall(firstContact.phoneNumber);
    } catch (_) {
      _showMessage(messenger, 'Unable to load your saved contacts right now.');
    } finally {
      if (mounted) {
        setState(() {
          _loadingCategory = null;
        });
      }
    }
  }

  double _distanceKm(double lat1, double lng1, double lat2, double lng2) {
    const earthRadiusKm = 6371.0;
    final lat1Rad = lat1 * (pi / 180);
    final lat2Rad = lat2 * (pi / 180);
    final deltaLat = (lat2 - lat1) * (pi / 180);
    final deltaLng = (lng2 - lng1) * (pi / 180);

    final a =
        sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLng / 2) * sin(deltaLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  void _showMessage(ScaffoldMessengerState messenger, String message) {
    if (!mounted) return;
    messenger.showSnackBar(SnackBar(content: Text(message)));
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
            onPressed: () async {
              Navigator.pop(ctx);
              // context.push('/sos');
              await LauncherHelper.makeCall('119');
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

  void showEmergencyRadialMenu(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      pageBuilder: (ctx, _, _) => EmergencyRadialMenu(
        onDismiss: () => Navigator.pop(ctx),
        onSelect: (incidentType) {
          Navigator.pop(ctx);
          context.push('/emergency-report', extra: incidentType);
        },
      ),
    );
  }
}
