import 'package:flutter/material.dart';
import 'service_contacts_screen.dart';

class FireStationScreen extends StatelessWidget {
  const FireStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServiceContactsScreen(
      category: 'fire_station',
      title: 'Fire Station',
    );
  }
}
