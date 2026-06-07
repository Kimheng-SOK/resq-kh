import 'package:flutter/material.dart';
import 'package:app/core/theme/app_color.dart';

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
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dimColor = isDark ? Colors.white70 : AppColors.textSecondary;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
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
                    color: dimColor,
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
            child: _NotificationBell(hasNotification: hasNotification),
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
                border: Border.all(color: const Color(0xFFCCCCCC), width: 1.5),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF555555),
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

  const _NotificationBell({required this.hasNotification});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF555555),
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
                  color: Color(0xFFD32F2F),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
