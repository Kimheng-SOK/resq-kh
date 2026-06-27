import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/service_utils.dart';

/// Represents a single category in the "Seek Help" horizontal chip row.
class _CategoryChip {
  final String id;
  final String label;
  final IconData icon;
  final Color color;

  const _CategoryChip({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}

final List<_CategoryChip> _categories = [
  _CategoryChip(
    id: 'contacts',
    label: 'Contacts',
    icon: ServiceUtils.iconForType('general'),
    color: ServiceUtils.colorForType('general'),
  ),
  _CategoryChip(
    id: 'police',
    label: 'Police',
    icon: ServiceUtils.iconForType('police'),
    color: ServiceUtils.colorForType('police'),
  ),
  _CategoryChip(
    id: 'fire',
    label: 'Fire',
    icon: ServiceUtils.iconForType('fire'),
    color: ServiceUtils.colorForType('fire'),
  ),
  _CategoryChip(
    id: 'hospital',
    label: 'Hospital',
    icon: ServiceUtils.iconForType('hospital'),
    color: ServiceUtils.colorForType('hospital'),
  ),
  _CategoryChip(
    id: 'ambulance',
    label: 'Ambulance',
    icon: ServiceUtils.iconForType('ambulance'),
    color: ServiceUtils.colorForType('ambulance'),
  ),
  _CategoryChip(
    id: 'other',
    label: 'Other',
    icon: ServiceUtils.iconForType('helpline'),
    color: ServiceUtils.colorForType('helpline'),
  ),
];

class SeekHelpRow extends StatefulWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const SeekHelpRow({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<SeekHelpRow> createState() => _SeekHelpRowState();
}

class _SeekHelpRowState extends State<SeekHelpRow> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Map<String, String> categoryLabels = {
      'contacts': l10n.contactsLabel,
      'police': l10n.policeLabel,
      'fire': l10n.fireLabel,
      'hospital': l10n.hospital,
      'ambulance': l10n.ambulance,
      'other': l10n.otherLabel,
    };

    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const ClampingScrollPhysics(),
        children: _categories.map((cat) {
          final isSelected = widget.selectedCategory == cat.id;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                widget.onCategorySelected(isSelected ? null : cat.id);
              },
              child: SizedBox(
                width: 64,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cat.color.withAlpha(25)
                            : isDark
                            ? const Color(0xFF2C2C2C)
                            : const Color(0xFFF3F3F4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? cat.color.withAlpha(50)
                              : cat.color.withAlpha(30),
                          width: isSelected ? 2 : 1.5,
                        ),
                      ),
                      child: Icon(
                        cat.icon,
                        color: isSelected ? cat.color : cat.color.withAlpha(180),
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      categoryLabels[cat.id] ?? cat.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? cat.color
                            : isDark
                            ? Colors.white70
                            : const Color(0xFF1A1C1C),
                        fontFamily: 'SF Pro Display',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
