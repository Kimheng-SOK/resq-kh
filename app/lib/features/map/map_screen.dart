import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_color.dart';
import '../../core/data/mock_services.dart';
import '../../core/models/emergency_service.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allServices = getAllServices();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final shadowColor = isDark ? Colors.black54 : AppColors.shadow;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(11.5620, 104.9160),
              initialZoom: 13.0,
              minZoom: 10.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.resqkh.app',
              ),
              MarkerLayer(
                markers: allServices.map((service) {
                  return Marker(
                    point: LatLng(service.latitude, service.longitude),
                    width: 44,
                    height: 44,
                    child: GestureDetector(
                      onTap: () => _showBottomSheet(context, service),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getColor(service.type),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _getColor(service.type)
                                  .withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(_getIcon(service.type),
                            color: Colors.white, size: 24),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: GestureDetector(
              onTap: () => context.go('/'),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: shadowColor,
                        blurRadius: 8,
                        offset: const Offset(0, 2)),
                  ],
                ),
                child: Icon(Icons.arrow_back_rounded,
                    color: onSurface, size: 24),
              ),
            ),
          ),

          // Legend
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LegendItem(
                      color: AppColors.hospital,
                      label: 'Hospital',
                      textColor: onSurface),
                  const SizedBox(height: 6),
                  _LegendItem(
                      color: AppColors.police,
                      label: 'Police',
                      textColor: onSurface),
                  const SizedBox(height: 6),
                  _LegendItem(
                      color: AppColors.fire,
                      label: 'Fire',
                      textColor: onSurface),
                  const SizedBox(height: 6),
                  _LegendItem(
                      color: AppColors.ambulance,
                      label: 'Ambulance',
                      textColor: onSurface),
                ],
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

  void _showBottomSheet(BuildContext context, EmergencyService service) {
    final color = _getColor(service.type);
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final dimColor = theme.textTheme.bodyMedium!.color!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dimColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_getIcon(service.type), color: color, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service.name,
                            style: TextStyle(
                                color: onSurface,
                                fontSize: 17,
                                fontWeight: FontWeight.w700)),
                        Text(
                            '${service.distanceKm.toStringAsFixed(1)} km away',
                            style: TextStyle(color: dimColor, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: dimColor.withValues(alpha: 0.2)),
              const SizedBox(height: 12),
              _BottomSheetAction(
                icon: Icons.call_rounded,
                label: service.phone,
                color: color,
                onTap: () async {
                  final uri = Uri.parse('tel:${service.phone}');
                  if (await canLaunchUrl(uri)) await launchUrl(uri);
                },
              ),
              const SizedBox(height: 8),
              _BottomSheetAction(
                icon: Icons.directions_rounded,
                label: service.address,
                onTap: () async {
                  final uri = Uri.parse(
                    'https://www.google.com/maps/dir/?api=1&destination=${service.latitude},${service.longitude}',
                  );
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              const SizedBox(height: 8),
              _BottomSheetAction(
                icon: Icons.info_outline_rounded,
                label: 'View Full Details',
                onTap: () {
                  Navigator.pop(ctx);
                  context.push('/services/${service.id}');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSheetAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _BottomSheetAction({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final dimColor = theme.textTheme.bodyMedium!.color!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: (color ?? dimColor).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color ?? dimColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      color: color ?? onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: color ?? dimColor),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final Color textColor;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}
