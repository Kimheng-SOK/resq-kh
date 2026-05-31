import 'package:app/widgets/refresh_drag_pop_widget.dart';
import 'package:flutter/material.dart';
import 'service_model.dart';
import 'widgets/service_card.dart';

class AmbulanceScreen extends StatelessWidget {
  const AmbulanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ambulanceServices = [
      Service(
        id: '1',
        name: 'Calmette Hospital',
        phoneNumber: '119',
        address: 'Phnom Penh',
        type: 'Ambulance',
      ),
      Service(
        id: '2',
        name: 'Royal Phnom Penh Hospital',
        phoneNumber: '119',
        address: 'Sen Sok',
        type: 'Ambulance',
      ),
      Service(
        id: '3',
        name: 'Sunrise Japan Hospital',
        phoneNumber: '119',
        address: 'Chroy Changvar',
        type: 'Ambulance',
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
              'Ambulance Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          ...ambulanceServices.map((service) => ServiceCard(service: service)),
        ],
      ),
    );
  }
}
