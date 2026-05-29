import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_color.dart';
import '../../core/data/mock_services.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceId;

  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final service = getServiceById(serviceId);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final dimColor = theme.textTheme.bodyMedium!.color!;

    if (service == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text('Service not found',
              style: TextStyle(fontSize: 16, color: dimColor)),
        ),
      );
    }

    final color = _getColor(service.type);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(_getIcon(service.type),
                                color: color, size: 36),
                          ),
                          const SizedBox(height: 14),
                          Text(service.name,
                              style: TextStyle(
                                  color: onSurface,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(service.type.toUpperCase(),
                                style: TextStyle(
                                    color: color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Contact info
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Contact Information',
                              style: TextStyle(
                                  color: onSurface,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 16),
                          _InfoRow(icon: Icons.call_rounded, label: 'Phone', value: service.phone, color: color),
                          const SizedBox(height: 12),
                          _InfoRow(icon: Icons.location_on_rounded, label: 'Address', value: service.address),
                          const SizedBox(height: 12),
                          _InfoRow(icon: Icons.access_time_rounded, label: 'Hours', value: service.hours ?? 'Not specified'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Services offered
                  if (service.servicesOffered.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Services Offered',
                                style: TextStyle(
                                    color: onSurface,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 12),
                            ...service.servicesOffered.map((s) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle)),
                                      const SizedBox(width: 10),
                                      Text(s,
                                          style: TextStyle(
                                              color: onSurface,
                                              fontSize: 15)),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Distance
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(Icons.near_me_rounded,
                              color: dimColor, size: 20),
                          const SizedBox(width: 10),
                          Text(
                              '${service.distanceKm.toStringAsFixed(1)} km from your location',
                              style: TextStyle(
                                  color: onSurface,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _makeCall(service.phone),
                  icon: const Icon(Icons.call_rounded, size: 24),
                  label: const Text('CALL NOW',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(String type) {
    switch (type) {
      case 'police': return AppColors.police;
      case 'hospital': return AppColors.hospital;
      case 'fire': return AppColors.fire;
      case 'ambulance': return AppColors.ambulance;
      default: return AppColors.red;
    }
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'police': return Icons.local_police_rounded;
      case 'hospital': return Icons.local_hospital_rounded;
      case 'fire': return Icons.local_fire_department_rounded;
      case 'ambulance': return Icons.airport_shuttle_rounded;
      default: return Icons.emergency_rounded;
    }
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final dimColor = theme.textTheme.bodyMedium!.color!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color ?? dimColor),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: dimColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(value,
                style: TextStyle(
                    color: onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
