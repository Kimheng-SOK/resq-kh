import 'package:flutter/material.dart';

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

const List<_CategoryChip> _categories = [
  _CategoryChip(
    id: 'contacts',
    label: 'Contacts',
    icon: Icons.person_rounded,
    color: Color(0xFFAF101A),
  ),
  _CategoryChip(
    id: 'police',
    label: 'Police',
    icon: Icons.shield_rounded,
    color: Color(0xFF1565C0),
  ),
  _CategoryChip(
    id: 'fire',
    label: 'Fire',
    icon: Icons.local_fire_department_rounded,
    color: Color(0xFFF57C00),
  ),
  _CategoryChip(
    id: 'hospital',
    label: 'Hospital',
    icon: Icons.local_hospital_rounded,
    color: Color(0xFFAF101A),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: _categories.map((cat) {
          final isSelected = widget.selectedCategory == cat.id;

          return Container(
            alignment: Alignment.center,

            child: GestureDetector(
              onTap: () {
                widget.onCategorySelected(isSelected ? null : cat.id);
              },
              child: SizedBox(
                width: 68,
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
                        color: isSelected
                            ? cat.color
                            : cat.color.withAlpha(180),
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      cat.label,
                      style: TextStyle(
                        fontSize: 12,
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
