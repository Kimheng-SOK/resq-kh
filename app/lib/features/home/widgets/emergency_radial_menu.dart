import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/models/incident_type_model.dart';
import 'package:app/providers/incident_type_provider.dart';

IconData _iconFor(String name) {
  switch (name) {
    case 'fire': return Icons.local_fire_department;
    case 'car_crash': return Icons.car_crash;
    case 'medical': return Icons.medical_services;
    case 'police': return Icons.local_police;
    case 'water': return Icons.water;
    case 'storm': return Icons.storm;
    case 'shield': return Icons.shield;
    case 'bolt': return Icons.bolt;
    default: return Icons.warning_amber_rounded;
  }
}

class EmergencyRadialMenu extends ConsumerStatefulWidget {
  final void Function(IncidentType) onSelect;
  final VoidCallback onDismiss;

  const EmergencyRadialMenu({
    super.key,
    required this.onSelect,
    required this.onDismiss,
  });

  @override
  ConsumerState<EmergencyRadialMenu> createState() => _EmergencyRadialMenuState();
}

class _EmergencyRadialMenuState extends ConsumerState<EmergencyRadialMenu> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(incidentTypeProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(incidentTypeProvider);
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height / 2 - 60);
    final radius = size.width * 0.32;

    return GestureDetector(
      onTap: widget.onDismiss,
      child: Container(
        color: const Color.fromARGB(255, 233, 231, 231).withOpacity(0.75),
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : state.error != null
                ? Center(
                    child: Text('Failed to load: ${state.error}',
                        style: const TextStyle(color: Colors.white)))
                : Stack(
                    children: [
                      Positioned(
                        left: center.dx - 50,
                        top: center.dy - 50,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 217, 0, 0),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('SOS',
                                style: TextStyle(color: Color.fromARGB(255, 254, 254, 254), fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
                          ),
                        ),
                      ),
                      ...List.generate(state.types.length, (i) {
                        final angle = (2 * pi * i / state.types.length) - pi / 2;
                        final dx = center.dx + radius * cos(angle);
                        final dy = center.dy + radius * sin(angle);
                        final type = state.types[i];

                        return Positioned(
                          left: dx - 36,
                          top: dy - 36,
                          child: GestureDetector(
                            onTap: () => widget.onSelect(type),
                            child: Column(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 217, 0, 0),
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Icon(_iconFor(type.iconName),
                                      color: Colors.white, size: 26),
                                ),
                                const SizedBox(height: 6),
                                Text(type.label,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 18, 15, 15), 
                                      fontSize: 11, 
                                      fontWeight: FontWeight.w600, 
                                      decoration: TextDecoration.none,
                                    )
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
      ),
    );
  }
}