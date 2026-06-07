import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'downward_triangle_painter.dart';

/// A map marker showing a contact's profile photo, service icon, or
/// initials fallback with a downward-pointing caret.
///
/// Priority: [imageUrl] > [icon] > [initials] text.
class ContactProfileMarker extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final Color color;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isActive;

  const ContactProfileMarker({
    super.key,
    this.imageUrl,
    required this.initials,
    required this.color,
    this.icon,
    this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Photo card ──────────────────────────────────────
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isActive ? color : Colors.white,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: isActive
                      ? color.withAlpha(80)
                      : Colors.black.withAlpha(40),
                  blurRadius: isActive ? 12 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => _buildFallbackAvatar(),
                    errorWidget: (_, _, _) => _buildFallbackAvatar(),
                  )
                : _buildFallbackAvatar(),
          ),

          // ── Downward caret ──────────────────────────────────
          CustomPaint(
            size: const Size(16, 8),
            painter: DownwardTrianglePainter(
              color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackAvatar() {
    return Container(
      color: color.withAlpha(40),
      child: Center(
        child: icon != null
            ? Icon(icon, color: color, size: 24)
            : Text(
                initials,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'SF Pro Display',
                ),
              ),
      ),
    );
  }
}
