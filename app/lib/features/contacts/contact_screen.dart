import 'package:app/core/utils/service_utils.dart';
import 'package:app/widgets/refresh_drag_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshDragPopWidget(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 16),

          const Center(
            child: Text(
              'Emergency Services',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 32),
          _ServiceCard(
            title: ServiceUtils.labelForType('nearby'),
            subtitle: 'Services near your location',
            icon: ServiceUtils.iconForType('nearby'),
            color: ServiceUtils.colorForType('nearby'),
            onTap: () {
              context.go('/contacts/nearby');
            },
          ),
          const SizedBox(height: 16),
          _ServiceCard(
            title: ServiceUtils.labelForType('police'),
            subtitle: 'Request immediate assistance',
            icon: ServiceUtils.iconForType('police'),
            color: ServiceUtils.colorForType('police'),
            onTap: () {
              context.go('/contacts/police');
            },
          ),

          const SizedBox(height: 16),

          _ServiceCard(
            title: ServiceUtils.labelForType('hospital'),
            subtitle: 'Emergency rooms & trauma centers',
            icon: ServiceUtils.iconForType('hospital'),
            color: ServiceUtils.colorForType('hospital'),
            onTap: () {
              context.go('/contacts/hospital');
            },
          ),

          const SizedBox(height: 16),

          _ServiceCard(
            title: ServiceUtils.labelForType('ambulance'),
            subtitle: 'Medical & paramedics',
            icon: ServiceUtils.iconForType('ambulance'),
            color: ServiceUtils.colorForType('ambulance'),
            onTap: () {
              context.go('/contacts/ambulance');
            },
          ),

          const SizedBox(height: 16),

          _ServiceCard(
            title: ServiceUtils.labelForType('fire'),
            subtitle: 'Fire & rescue emergencies',
            icon: ServiceUtils.iconForType('fire'),
            color: ServiceUtils.colorForType('fire'),
            onTap: () {
              context.go('/contacts/fire');
            },
          ),

          const SizedBox(height: 16),

          _ServiceCard(
            title: ServiceUtils.labelForType('general'),
            subtitle: 'Personal emergency contacts',
            icon: ServiceUtils.iconForType('general'),
            color: ServiceUtils.colorForType('general'),
            onTap: () {
              context.go('/contacts/general');
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(subtitle),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
