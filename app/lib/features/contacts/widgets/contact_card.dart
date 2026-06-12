import 'package:app/core/theme/app_color.dart';
import 'package:app/core/utils/launcher_helper.dart';
import 'package:app/features/contacts/models/contacts_model.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;

  const ContactCard({
    super.key,
    required this.contact,
    this.onDelete,
    this.onEdit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final initials = contact.name.isNotEmpty
        ? contact.name[0].toUpperCase()
        : '?';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // ── Avatar ──────────────────────────────────────
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.red,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // ── Name + Phone ────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_rounded,
                          size: 14,
                          color: isDark ? Colors.white38 : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          contact.phoneNumber,
                          style: TextStyle(
                            color: isDark ? Colors.white54 : AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Call button ─────────────────────────────────
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  onPressed: () => LauncherHelper.makeCall(contact.phoneNumber),
                  icon: const Icon(Icons.phone_rounded),
                  color: AppColors.success,
                  iconSize: 22,
                  tooltip: 'Call ${contact.name}',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
