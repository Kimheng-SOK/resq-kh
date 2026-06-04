import 'package:app/widgets/refresh_drag_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/models/service_model.dart';
import 'widgets/service_card.dart';

class FireStationScreen extends StatelessWidget {
  const FireStationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fireStations = [
      Service(
        id: '1',
        name: 'Fire Station 1',
        phoneNumber: '118',
        address: 'Phnom Penh',
        type: 'Fire',
      ),
      Service(
        id: '2',
        name: 'Fire Station 2',
        phoneNumber: '118',
        address: 'Toul Kork',
        type: 'Fire',
      ),
      Service(
        id: '3',
        name: 'Fire Station 3',
        phoneNumber: '118',
        address: 'Sen Sok',
        type: 'Fire',
      ),
    ];

    return RefreshDragPopWidget(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Text(
              'Fire Station Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          ...fireStations.map((service) => ServiceCard(service: service)),
        ],
      ),
    );
  }
}
