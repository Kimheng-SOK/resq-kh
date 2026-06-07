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

class MapDetailScreen extends StatelessWidget {
  final EmergencyContact contact;

  const MapDetailScreen({super.key, required this.contact});

  static const LatLng _defaultCenter = LatLng(11.5564, 104.9282);

  @override
  Widget build(BuildContext context) {
    final color = ServiceUtils.colorForType(contact.type);
    final icon = ServiceUtils.iconForType(contact.type);
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildMap(color, icon),

          Positioned(
            top: topPadding + 8,
            left: 16,
            child: _BackButton(onTap: () => context.pop()),
          ),

          Positioned(
            top: topPadding + 64,
            right: 16,
            child: _buildFilterColumn(context),
          ),

          _buildActionCard(context, color, icon, screenHeight),
        ],
      ),
    );
  }

  // ── Map ────────────────────────────────────────────────────────

  Widget _buildMap(Color color, IconData icon) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.33,
        0.59,
        0.11,
        0,
        0,
        0.33,
        0.59,
        0.11,
        0,
        0,
        0.33,
        0.59,
        0.11,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: FlutterMap(
        options: const MapOptions(
          initialCenter: _defaultCenter,
          initialZoom: 14,
          interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.resqkh.app',
          ),
          MarkerLayer(
            markers: [
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
    );
  }

  Widget _buildFilterColumn(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final screenWidth = MediaQuery.of(context).size.width;
    final btnSize = screenWidth < 360 ? 40.0 : 48.0;
    final iconSize = screenWidth < 360 ? 20.0 : 24.0;

    return Column(
      spacing: screenWidth < 360 ? 8 : 12,
      children: [
        _FilterBtn(
          icon: Icons.local_hospital_rounded,
          color: AppColors.red,
          size: btnSize,
          iconSize: iconSize,
          isDark: isDark,
        ),
        _FilterBtn(
          icon: Icons.navigation_rounded,
          color: const Color(0xFF005FB0),
          size: btnSize,
          iconSize: iconSize,
          isDark: isDark,
        ),
        _FilterBtn(
          icon: Icons.local_fire_department_rounded,
          color: const Color(0xFFF57C00),
          size: btnSize,
          iconSize: iconSize,
          isDark: isDark,
        ),
        SizedBox(
          width: btnSize,
          child: Divider(
            height: 1,
            color: isDark ? Colors.white24 : const Color(0xFFE4BEBA),
          ),
        ),
        _FilterBtn(
          icon: Icons.layers_rounded,
          color: const Color(0xFF1A1C1C),
          size: btnSize,
          iconSize: iconSize,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    Color color,
    IconData icon,
    double screenHeight,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final screenWidth = MediaQuery.of(context).size.width;
    final hInset = screenWidth < 360 ? 12.0 : 24.0;

    return Positioned(
      bottom: bottomPadding + 8,
      left: hInset,
      right: hInset,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Close button row ──────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(bottom: 4, right: 4),
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

          Container(
            constraints: BoxConstraints(
              // Card takes at most 45% of screen height
              maxHeight: screenHeight * 0.45,
            ),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth < 360 ? 16 : 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ServiceInfoRow(color: color, icon: icon),
                    SizedBox(height: screenWidth < 360 ? 12 : 16),

                    _CallEmergencyBtn(phone: contact.phone),
                    SizedBox(height: screenWidth < 360 ? 6 : 8),

                    _ActionBtnRow(
                      contact: contact,
                      isDark: isDark,
                      compact: screenWidth < 360,
                    ),
                  ],
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

class _ServiceInfoRow extends StatelessWidget {
  final Color color;
  final IconData icon;

  const _ServiceInfoRow({required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final detailScreen = context
        .findAncestorWidgetOfExactType<MapDetailScreen>()!;
    final contact = detailScreen.contact;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 360;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon tile
        Container(
          width: isCompact ? 44 : 56,
          height: isCompact ? 44 : 56,
          decoration: BoxDecoration(
            color: isDark ? color.withAlpha(30) : const Color(0xFFF3F3F4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(50), width: 2),
          ),
          child: Icon(icon, color: color, size: isCompact ? 22 : 28),
        ),
        SizedBox(width: isCompact ? 12 : 16),
        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                contact.name,
                style: TextStyle(
                  fontSize: isCompact ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                  fontFamily: 'SF Pro Display',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isCompact ? 2 : 4),
              Text(
                contact.address,
                style: TextStyle(
                  fontSize: isCompact ? 12 : 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white54 : AppColors.textSecondary,
                  fontFamily: 'SF Pro Display',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isCompact ? 4 : 6),
              // Status badge
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
                  SizedBox(width: isCompact ? 4 : 8),
                  Flexible(
                    child: Text(
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CallEmergencyBtn extends StatelessWidget {
  final String phone;

  const _CallEmergencyBtn({required this.phone});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 360;

    return SizedBox(
      width: double.infinity,
      height: isCompact ? 48 : 56,
      child: ElevatedButton(
        onPressed: () => LauncherHelper.makeCall(phone),
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
            Icon(Icons.phone_rounded, size: isCompact ? 16 : 18),
            SizedBox(width: isCompact ? 8 : 12),
            Text(
              'CALL EMERGENCY',
              style: TextStyle(
                fontSize: isCompact ? 14 : 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.45,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtnRow extends StatelessWidget {
  final EmergencyContact contact;
  final bool isDark;
  final bool compact;

  const _ActionBtnRow({
    required this.contact,
    required this.isDark,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => LauncherHelper.makeCall(contact.phone),
            icon: Icon(
              Icons.phone_rounded,
              size: compact ? 16 : 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: Text(
              'Contact',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: compact ? 13 : 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro Display',
              ),
            ),
            style: _outlinedStyle(compact),
          ),
        ),
        SizedBox(width: compact ? 6 : 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () =>
                LauncherHelper.openMap('${contact.lat},${contact.lng}'),
            icon: Icon(
              Icons.directions_rounded,
              size: compact ? 16 : 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            label: Text(
              'Directions',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: compact ? 13 : 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro Display',
              ),
            ),
            style: _outlinedStyle(compact),
          ),
        ),
      ],
    );
  }

  ButtonStyle _outlinedStyle(bool compact) {
    return OutlinedButton.styleFrom(
      minimumSize: Size(0, compact ? 42 : 48),
      side: BorderSide(
        color: isDark ? Colors.white24 : const Color(0xFFE4BEBA),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
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
    );
  }
}

class _FilterBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final bool isDark;

  const _FilterBtn({
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(size / 3),
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
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}
