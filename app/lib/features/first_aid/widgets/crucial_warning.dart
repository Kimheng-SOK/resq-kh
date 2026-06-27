import 'package:app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
 
class CrucialWarning extends StatelessWidget {
  final String title;
  final String message;
 
  const CrucialWarning({
    super.key,
    this.title = 'CRUCIAL WARNING',
    required this.message,
  });
 
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      container: true,
      label: l10n.crucialWarning,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFFE8E8E8),
          border: Border(
            left: BorderSide(
              color: Color(0xFFAF101A),
              width: 4,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.crucialWarning,
              style: const TextStyle(
                color: Color(0xFFAF101A),
                fontWeight: FontWeight.bold,
                fontSize: 18,
                height: 28 / 18,
                letterSpacing: 0.05 * 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(
                color: Color(0xFF1A1C1C),
                fontSize: 18,
                height: 28 / 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}