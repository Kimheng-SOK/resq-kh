import 'package:flutter/material.dart';
import 'service_contacts_screen.dart';

class AmbulanceScreen extends StatelessWidget {
  const AmbulanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServiceContactsScreen(
      category: 'ambulance',
      title: 'Ambulance',
    );
  }
}
