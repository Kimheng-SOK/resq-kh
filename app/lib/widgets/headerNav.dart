import 'package:flutter/material.dart';
import '../core/theme/app_color.dart';

class HeaderNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final bool hasNotification;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const HeaderNavBar({
    super.key,
    required this.userName,
    this.hasNotification = false,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final dimColor = isDark ? const Color(0xFFAAAAAA) : const Color(0xFF555555);
    final borderColor =
        isDark ? const Color(0xFF555555) : const Color(0xFFCCCCCC);

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Greeting + Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hey!',
                  style: TextStyle(
                    color: dimColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName.toUpperCase(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell
          GestureDetector(
            onTap: onNotificationTap,
            child: _NotificationBell(
              hasNotification: hasNotification,
              iconColor: dimColor,
            ),
          ),

          const SizedBox(width: 16),

          // Profile Icon
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Icon(
                Icons.person_outline_rounded,
                color: dimColor,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Notification bell with optional red dot indicator
class _NotificationBell extends StatelessWidget {
  final bool hasNotification;
  final Color iconColor;

  const _NotificationBell({
    required this.hasNotification,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            color: iconColor,
            size: 26,
          ),
          if (hasNotification)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
