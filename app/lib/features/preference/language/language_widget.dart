import 'package:app/features/preference/language/card_language.dart';
import 'package:flutter/material.dart';
import 'package:app/core/utils/country_code.dart';
import 'package:app/core/l10n/app_localizations.dart';
import 'package:app/features/preference/language/diver_widget.dart';

class LanguageCard extends StatelessWidget {
  final String language;
  final Color onSurface;
  final Color dimColor;
  final ValueChanged<String> onLanguageChanged;

  const LanguageCard({
    super.key,
    required this.language,
    required this.onSurface,
    required this.dimColor,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.translate_rounded, color: dimColor, size: 22),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appLanguage,
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      CountryCode.getLanguageName(language),
                      style: TextStyle(
                        color: dimColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                CardLanguage(code: 'en', onTap: () => onLanguageChanged('en')),
                const DividerWidget(),
                CardLanguage(code: 'km', onTap: () => onLanguageChanged('km')),
                const DividerWidget(),
                CardLanguage(code: 'zh', onTap: () => onLanguageChanged('zh')),
                const DividerWidget(),
                CardLanguage(code: 'fr', onTap: () => onLanguageChanged('fr')),
                const DividerWidget(),
                CardLanguage(code: 'ja', onTap: () => onLanguageChanged('ja')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
