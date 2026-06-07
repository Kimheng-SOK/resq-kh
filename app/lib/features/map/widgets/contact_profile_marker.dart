import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'downward_triangle_painter.dart';

/// A map marker showing a contact's profile photo (or initials fallback)
/// with a downward-pointing caret, styled like a map pin.
class ContactProfileMarker extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final Color color;
  final VoidCallback? onTap;
  final bool isActive;

  const ContactProfileMarker({
    super.key,
    this.imageUrl,
    required this.initials,
    required this.color,
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
                    placeholder: (_, _) => _buildInitialsAvatar(),
                    errorWidget: (_, _, _) => _buildInitialsAvatar(),
                  )
                : _buildInitialsAvatar(),
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

  Widget _buildInitialsAvatar() {
    return Container(
      color: color.withAlpha(40),
      child: Center(
        child: Text(
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
