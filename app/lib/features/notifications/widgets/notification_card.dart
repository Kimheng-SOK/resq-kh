import 'package:app/models/emergency_report_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final EmergencyReport report;

  const NotificationCard({super.key, required this.report});

  Color get statusColor {
    switch (report.status.toLowerCase()) {
      case 'resolved':
        return Colors.green;
      case 'dispatched':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (report.incidentType.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department;
      case 'medical':
        return Icons.local_hospital;
      case 'electric hazard':
        return Icons.electric_bolt;
      case 'crime':
        return Icons.local_police;
      default:
        return Icons.warning_amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 24, child: Icon(icon)),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.incidentType,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(report.description),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Chip(
                        label: Text(report.status),
                        backgroundColor: statusColor.withOpacity(.15),
                        labelStyle: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    DateFormat(
                      'dd MMM yyyy • hh:mm a',
                    ).format(report.createdAt),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
