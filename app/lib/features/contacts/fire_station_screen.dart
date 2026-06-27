import 'package:app/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'service_contacts_screen.dart';

class FireStationScreen extends StatelessWidget {
  const FireStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ServiceContactsScreen(
      category: 'fire_station',
      title: l10n.fireStation,
    );
  }
}
