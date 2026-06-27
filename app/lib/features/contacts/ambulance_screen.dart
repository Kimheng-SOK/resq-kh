import 'package:app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'service_contacts_screen.dart';

class AmbulanceScreen extends StatelessWidget {
  const AmbulanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ServiceContactsScreen(
      category: 'ambulance',
      title: l10n.ambulance,
    );
  }
}
