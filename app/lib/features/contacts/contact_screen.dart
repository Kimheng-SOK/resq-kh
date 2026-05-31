import 'package:app/widgets/refresh_drag_pop_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
          title: 'Police',
          subtitle: 'Request immediate assistance',
          icon: Icons.local_police,
          color: Colors.blue,
          onTap: () {
            context.go('/contacts/police');
          },
        ),

        const SizedBox(height: 16),

        _ServiceCard(
          title: 'Ambulance',
          subtitle: 'Medical & paramedics',
          icon: Icons.medical_services,
          color: Colors.red,
          onTap: () {
            context.go('/contacts/ambulance');
          },
        ),

        const SizedBox(height: 16),

        _ServiceCard(
          title: 'Fire Station',
          subtitle: 'Fire & rescue emergencies',
          icon: Icons.local_fire_department,
          color: Colors.orange,
          onTap: () {
            context.go('/contacts/fire');
          },
        ),

        const SizedBox(height: 16),

        _ServiceCard(
          title: 'General Contact',
          subtitle: 'Personal emergency contacts',
          icon: Icons.people,
          color: Colors.green,
          onTap: () {
            context.go('/contacts/general');
          },
        ),
      ],
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
    return RefreshDragPopWidget(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      child: Card(
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
      ),
    );
  }
}
