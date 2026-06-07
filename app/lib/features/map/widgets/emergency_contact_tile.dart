import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../../../models/emergency_contact.dart';

/// A single row in the emergency contacts list inside the
/// DraggableScrollableSheet on the Map screen.
class EmergencyContactTile extends StatelessWidget {
  final EmergencyContact contact;
  final VoidCallback? onTap;
  final VoidCallback? onNotifyTap;

  const EmergencyContactTile({
    super.key,
    required this.contact,
    this.onTap,
    this.onNotifyTap,
  });

  /// Maps a contact type to a display color for the avatar.
  static Color _colorForType(String type) {
    switch (type) {
      case 'police':
        return AppColors.police;
      case 'hospital':
        return AppColors.hospital;
      case 'fire':
        return AppColors.fire;
      case 'ambulance':
        return AppColors.ambulance;
      case 'helpline':
        return AppColors.success;
      case 'disaster':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  /// Generates initials from a contact name (up to 2 characters).
  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = _colorForType(contact.type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          children: [
            // ── Avatar ────────────────────────────────────────
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withAlpha(isDark ? 40 : 25),
              child: Text(
                _initials(contact.name),
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Name + subtitle ───────────────────────────────
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    contact.address,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white54 : AppColors.textSecondary,
                      fontFamily: 'SF Pro Display',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── Notification bell ─────────────────────────────
            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: isDark ? Colors.white54 : AppColors.textSecondary,
              ),
              onPressed: onNotifyTap,
              tooltip: 'Notify this contact',
            ),
          ],
        ),
      ),
    );
  }
}
