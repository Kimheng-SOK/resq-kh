import 'package:flutter/material.dart';
import 'service_contacts_screen.dart';

class HospitalScreen extends StatelessWidget {
  const HospitalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServiceContactsScreen(
      category: 'hospital',
      title: 'Hospital',
    );
  }
}
