import 'package:app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'service_contacts_screen.dart';

class PoliceScreen extends StatelessWidget {
  const PoliceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ServiceContactsScreen(
      category: 'police',
      title: l10n.policeLabel,
    );
  }
}
