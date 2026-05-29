import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_color.dart';
import '../../core/data/mock_services.dart';
import '../../core/models/emergency_service.dart';

class ServiceListScreen extends StatelessWidget {
  final String serviceType;

  const ServiceListScreen({super.key, required this.serviceType});

  String get _title {
    switch (serviceType) {
      case 'police': return 'Police Stations';
      case 'hospital': return 'Hospitals';
      case 'fire': return 'Fire Stations';
      case 'ambulance': return 'Ambulance Services';
      default: return 'Services';
    }
  }

  IconData get _icon {
    switch (serviceType) {
      case 'police': return Icons.local_police_rounded;
      case 'hospital': return Icons.local_hospital_rounded;
      case 'fire': return Icons.local_fire_department_rounded;
      case 'ambulance': return Icons.airport_shuttle_rounded;
      default: return Icons.emergency_rounded;
    }
  }

  Color get _color {
    switch (serviceType) {
      case 'police': return AppColors.police;
      case 'hospital': return AppColors.hospital;
      case 'fire': return AppColors.fire;
      case 'ambulance': return AppColors.ambulance;
      default: return AppColors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = getServicesByType(serviceType);
    final theme = Theme.of(context);
    final dimColor = theme.textTheme.bodyMedium!.color!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, color: _color, size: 24),
            const SizedBox(width: 8),
            Text(_title),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: services.isEmpty
          ? Center(
              child: Text(
                'No services found nearby.',
                style: TextStyle(color: dimColor, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return _ServiceCard(
                  service: services[index],
                  color: _color,
                  index: index,
                );
              },
            ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final EmergencyService service;
  final Color color;
  final int index;

  const _ServiceCard({
    required this.service,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final dimColor = theme.textTheme.bodyMedium!.color!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.name,
                          style: TextStyle(
                              color: onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 14, color: dimColor),
                          const SizedBox(width: 4),
                          Text('${service.distanceKm.toStringAsFixed(1)} km away',
                              style:
                                  TextStyle(color: dimColor, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.place_outlined, size: 16, color: dimColor),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(service.address,
                      style: TextStyle(color: dimColor, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: dimColor.withValues(alpha: 0.2)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () => _makeCall(service.phone),
                      icon: const Icon(Icons.call_rounded, size: 20),
                      label: const Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/services/${service.id}'),
                      icon: const Icon(Icons.info_outline_rounded, size: 20),
                      label: const Text('Details'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color,
                        side: BorderSide(color: color),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}
