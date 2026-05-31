import 'package:app/widgets/refresh_drag_pop_widget.dart';
import 'package:flutter/material.dart';
import 'service_model.dart';
import 'widgets/service_card.dart';

class PoliceScreen extends StatelessWidget {
  const PoliceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final policeStations = [
      Service(
        id: '1',
        name: 'BKK1 Police Station',
        phoneNumber: '117',
        address: 'Boeung Keng Kang 1',
        type: 'Police',
      ),
      Service(
        id: '2',
        name: 'Chamkar Mon Police',
        phoneNumber: '117',
        address: 'Chamkar Mon District',
        type: 'Police',
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
              'Police Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          ...policeStations.map((service) => ServiceCard(service: service)),
        ],
      ),
    );
  }
}
