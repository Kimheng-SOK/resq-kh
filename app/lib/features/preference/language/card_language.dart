import 'package:flutter/material.dart';
import 'package:app/core/utils/country_code.dart';
import 'package:country_flags/country_flags.dart';

class CardLanguage extends StatelessWidget {
  final String code;
  final VoidCallback onTap;

  const CardLanguage({super.key, required this.code, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          children: [
            CountryFlag.fromLanguageCode(
              code,
              theme: const ImageTheme(shape: Circle(), width: 24, height: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                CountryCode.getLanguageName(code),
                style: TextStyle(
                  color: onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
