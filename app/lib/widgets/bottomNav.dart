import 'package:flutter/material.dart';
import '../core/theme/app_color.dart';
import 'package:app/core/utils/emergency_menu_helper.dart';
import 'package:app/core/l10n/app_localizations.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              _NavItem(
                index: 0,
                icon: Icons.home_rounded,
                activeIcon: Icons.home_rounded,
                label: l10n.navHome,
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                index: 1,
                icon: Icons.map_rounded,
                activeIcon: Icons.map_rounded,
                label: l10n.navMap,
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _SOSNavItem(
                isSelected: currentIndex == 2,
                onTap: () => showEmergencyRadialMenu(context),
                onLongPress: () => showEmergencyRadialMenu(context),
              ),
              _NavItem(
                index: 3,
                icon: Icons.people_rounded,
                activeIcon: Icons.people_rounded,
                label: l10n.navContacts,
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                index: 4,
                icon: Icons.medical_services_rounded,
                activeIcon: Icons.medical_services_rounded,
                label: l10n.navFirstAid,
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSOSBottomSheet(BuildContext context) async {
    final String? type = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const _SOSEmergencySheet(),
    );
    if (type != null && context.mounted) {
      onTap(2);
      // TODO: route to '/services/$type' once the router supplies those paths
    }
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color fgColor = isSelected
        ? AppColors.red
        : isDark
        ? Colors.white54
        : AppColors.textSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Indicator pill ────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: isSelected ? 36 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 6),
              // ── Icon ──────────────────────────────────────
              Icon(isSelected ? activeIcon : icon, size: 26, color: fgColor),
              const SizedBox(height: 4),
              // ── Label ─────────────────────────────────────
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: fgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SOSNavItem extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _SOSNavItem({
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Indicator pill ────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: isSelected ? 36 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.red : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 4),
              // ── SOS circle ────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.red.withAlpha(isSelected ? 140 : 80),
                      blurRadius: isSelected ? 18 : 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: isSelected
                      ? Border.all(
                          color: Colors.white.withAlpha(90),
                          width: 2.5,
                        )
                      : null,
                ),
                child: const Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyType {
  final String id;
  final IconData icon;
  final Color color;

  const _EmergencyType({
    required this.id,
    required this.icon,
    required this.color,
  });
}

const List<_EmergencyType> _emergencyTypes = [
  _EmergencyType(
    id: 'police',
    icon: Icons.local_police_rounded,
    color: AppColors.police,
  ),
  _EmergencyType(
    id: 'hospital',
    icon: Icons.local_hospital_rounded,
    color: AppColors.hospital,
  ),
  _EmergencyType(
    id: 'fire',
    icon: Icons.local_fire_department_rounded,
    color: AppColors.fire,
  ),
  _EmergencyType(
    id: 'ambulance',
    icon: Icons.airport_shuttle_rounded,
    color: AppColors.ambulance,
  ),
];

String _labelForEmergencyType(AppLocalizations l10n, String id) {
  switch (id) {
    case 'police': return l10n.policeLabel;
    case 'hospital': return l10n.hospital;
    case 'fire': return l10n.fireLabel;
    case 'ambulance': return l10n.ambulance;
    default: return '';
  }
}

class _SOSEmergencySheet extends StatelessWidget {
  const _SOSEmergencySheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(120),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Card ───────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Column(
              children: [
                // ── Header ──────────────────────────────────
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.red.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_rounded,
                    color: AppColors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.selectEmergencyType,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.whatKindOfHelp,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white54 : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // ── 2×2 Emergency type grid ─────────────────
                Row(
                  children: [
                    Expanded(
                      child: _EmergencyTypeCard(
                        type: _emergencyTypes[0],
                        label: _labelForEmergencyType(l10n, _emergencyTypes[0].id),
                        onTap: () =>
                            Navigator.pop(context, _emergencyTypes[0].id),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _EmergencyTypeCard(
                        type: _emergencyTypes[1],
                        label: _labelForEmergencyType(l10n, _emergencyTypes[1].id),
                        onTap: () =>
                            Navigator.pop(context, _emergencyTypes[1].id),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _EmergencyTypeCard(
                        type: _emergencyTypes[2],
                        label: _labelForEmergencyType(l10n, _emergencyTypes[2].id),
                        onTap: () =>
                            Navigator.pop(context, _emergencyTypes[2].id),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _EmergencyTypeCard(
                        type: _emergencyTypes[3],
                        label: _labelForEmergencyType(l10n, _emergencyTypes[3].id),
                        onTap: () =>
                            Navigator.pop(context, _emergencyTypes[3].id),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Cancel ──────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white54
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Safe-area spacer
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

/// A single emergency type card inside the 2×2 grid.
class _EmergencyTypeCard extends StatelessWidget {
  final _EmergencyType type;
  final String label;
  final VoidCallback onTap;

  const _EmergencyTypeCard({required this.type, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? type.color.withAlpha(20) : type.color.withAlpha(15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: type.color.withAlpha(50), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: type.color.withAlpha(35),
                shape: BoxShape.circle,
              ),
              child: Icon(type.icon, color: type.color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
