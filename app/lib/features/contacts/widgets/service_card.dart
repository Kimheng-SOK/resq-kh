import 'package:flutter/material.dart';
import '../service_model.dart';
import '../../../core/utils/launcher_helper.dart';

class ServiceCard extends StatelessWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  IconData getServiceIcon() {
    switch (service.type) {
      case 'Police':
        return Icons.local_police;

      case 'Ambulance':
        return Icons.medical_services;

      case 'Fire':
        return Icons.local_fire_department;

      default:
        return Icons.location_on;
    }
  }

  Color getServiceColor() {
    switch (service.type) {
      case 'Police':
        return Colors.blue;

      case 'Ambulance':
        return Colors.red;

      case 'Fire':
        return Colors.orange;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getServiceColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.15),
                  child: Icon(getServiceIcon(), color: color),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(service.address),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: Colors.red),
                Text('${service.phoneNumber}'),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      LauncherHelper.makeCall(service.phoneNumber);
                    },
                    icon: const Icon(Icons.call),
                    label: const Text('Call'),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      LauncherHelper.openMap(service.address);
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Directions'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
