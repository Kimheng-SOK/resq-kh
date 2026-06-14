import 'package:flutter/material.dart';
import 'service_contacts_screen.dart';

class PoliceScreen extends StatelessWidget {
  const PoliceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServiceContactsScreen(
      category: 'police',
      title: 'Police',
    );
  }
}
