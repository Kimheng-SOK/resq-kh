import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_color.dart';
import '../../core/utils/launcher_helper.dart';
import '../../core/utils/service_utils.dart';
import '../../models/emergency_contact.dart';
import 'widgets/contact_profile_marker.dart';

import 'widgets/user_location_marker.dart';

/// Detail screen shown when the user taps an emergency contact marker on the
/// map. Displays a desaturated map with a floating action card containing
/// the service's full details and call-to-action buttons.
class MapDetailScreen extends StatelessWidget {
  final EmergencyContact contact;

  const MapDetailScreen({super.key, required this.contact});

  static const LatLng _defaultCenter = LatLng(11.5564, 104.9282);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = ServiceUtils.colorForType(contact.type);
    final icon = ServiceUtils.iconForType(contact.type);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── Layer 0: Desaturated map ──────────────────────
          ColorFiltered(
            colorFilter: const ColorFilter.matrix(<double>[
              0.33, 0.59, 0.11, 0, 0, //
              0.33, 0.59, 0.11, 0, 0, //
              0.33, 0.59, 0.11, 0, 0, //
              0, 0, 0, 1, 0, //
            ]),
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: _defaultCenter,
                initialZoom: 14,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.resqkh.app',
                ),
                MarkerLayer(
                  markers: [
                    // Contact marker at the selected contact's location
                    Marker(
                      point: LatLng(contact.lat, contact.lng),
                      width: 48,
                      height: 56,
                      child: ContactProfileMarker(
                        initials: _initials(contact.name),
                        color: color,
                        isActive: true,
                      ),
                    ),
                    // User location dot
                    const Marker(
                      point: _defaultCenter,
                      width: 32,
                      height: 32,
                      child: UserLocationMarker(),
                    ),
                  ],
                ),
                const RichAttributionWidget(
                  popupInitialDisplayDuration: Duration(seconds: 0),
                  attributions: [],
                ),
              ],
            ),
          ),

          // ── Layer 2: Header overlay ────────────────────────
          _buildHeaderOverlay(theme),

          // ── Layer 3: Floating filter buttons ────────────────
          _buildFilterButtons(theme),

          // ── Layer 4: Floating Action Card ───────────────────
          _buildActionCard(context, theme, color, icon),

          // ── Back button ────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 40,
                height: 40,
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
                  Icons.arrow_back_rounded,
                  color: isDark ? Colors.white70 : AppColors.textSecondary,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header overlay ────────────────────────────────────────────

  Widget _buildHeaderOverlay(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      top: 0,
      left: 48,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              (isDark ? Colors.black : Colors.white).withAlpha(230),
              (isDark ? Colors.black : Colors.white).withAlpha(0),
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Center(
            child: Text(
              'SOS CAMBODIA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.6,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Filter buttons ────────────────────────────────────────────

  Widget _buildFilterButtons(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      top: 128,
      right: 24,
      child: Column(
        spacing: 12,
        children: [
          _FilterButton(
            icon: Icons.local_hospital_rounded,
            color: AppColors.red,
            isDark: isDark,
            onTap: () {},
          ),
          _FilterButton(
            icon: Icons.navigation_rounded,
            color: const Color(0xFF005FB0),
            isDark: isDark,
            onTap: () {},
          ),
          _FilterButton(
            icon: Icons.local_fire_department_rounded,
            color: const Color(0xFFF57C00),
            isDark: isDark,
            onTap: () {},
          ),
          // Divider in a 48-wide cell
          SizedBox(
            width: 48,
            child: Divider(
              height: 1,
              color: isDark ? Colors.white24 : const Color(0xFFE4BEBA),
            ),
          ),
          _FilterButton(
            icon: Icons.layers_rounded,
            color: const Color(0xFF1A1C1C),
            isDark: isDark,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── Floating Action Card ──────────────────────────────────────

  Widget _buildActionCard(
    BuildContext context,
    ThemeData theme,
    Color color,
    IconData icon,
  ) {
    final isDark = theme.brightness == Brightness.dark;

    return Positioned(
      bottom: 16,
      left: 24,
      right: 24,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Card body ──────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : const Color(0xFFE2E2E2),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black54 : const Color(0x40000000),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Service row ──────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon tile
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isDark
                            ? color.withAlpha(30)
                            : const Color(0xFFF3F3F4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: color.withAlpha(50),
                          width: 2,
                        ),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),

                    const SizedBox(width: 16),

                    // Info column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            contact.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            contact.address,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.textSecondary,
                              fontFamily: 'SF Pro Display',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Open 24 hours badge
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF22C55E),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                contact.hours == '24/7'
                                    ? 'OPEN 24 HOURS'
                                    : contact.hours.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF16A34A),
                                  letterSpacing: 0.5,
                                  fontFamily: 'SF Pro Display',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── CALL EMERGENCY CTA ───────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => LauncherHelper.makeCall(contact.phone),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: AppColors.red.withAlpha(80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.phone_rounded, size: 18),
                        const SizedBox(width: 12),
                        const Text(
                          'CALL EMERGENCY',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.45,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Contact + Directions buttons ─────────────
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            LauncherHelper.makeCall(contact.phone),
                        icon: Icon(
                          Icons.phone_rounded,
                          size: 18,
                          color: theme.colorScheme.onSurface,
                        ),
                        label: Text(
                          'Contact',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white24
                                : const Color(0xFFE4BEBA),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => LauncherHelper.openMap(
                          '${contact.lat},${contact.lng}',
                        ),
                        icon: Icon(
                          Icons.directions_rounded,
                          size: 18,
                          color: theme.colorScheme.onSurface,
                        ),
                        label: Text(
                          'Directions',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 48),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white24
                                : const Color(0xFFE4BEBA),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Close button (positioned outside top-right) ────
          Positioned(
            top: -11,
            right: -11,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1C1C),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ── Private sub-widgets ──────────────────────────────────────────

/// A single floating filter button on the right side of the detail screen.
class _FilterButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterButton({
    required this.icon,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xFFEEEEEE),
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black38 : AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
