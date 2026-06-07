import 'package:flutter/material.dart';
import 'urgency_card.dart';

class _Condition {
  final String id;
  final String title;
  final String description;
  final Widget icon;
  final Severity severity;
  final String severityLabel;

  const _Condition({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.severity,
    required this.severityLabel,
  });
}

const _conditions = [
  _Condition(
    id: 'cardiac-arrest',
    title: 'CARDIAC ARREST',
    description: 'Unconscious, not breathing, or only gasping.',
    icon: Icon(Icons.favorite, color: Colors.white, size: 36),
    severity: Severity.critical,
    severityLabel: 'CRITICAL',
  ),
  _Condition(
    id: 'heavy-bleeding',
    title: 'HEAVY BLEEDING',
    description: "Pulsing or steady flow of blood that won't stop.",
    icon: Icon(Icons.water_drop, color: Colors.white, size: 32),
    severity: Severity.critical,
    severityLabel: 'CRITICAL',
  ),
  _Condition(
    id: 'choking',
    title: 'CHOKING',
    description: 'Unable to speak, cough, or breathe effectively.',
    icon: Icon(Icons.air, color: Colors.white, size: 32),
    severity: Severity.urgent,
    severityLabel: 'URGENT',
  ),
  _Condition(
    id: 'unconscious',
    title: 'UNCONSCIOUS',
    description: 'Non-responsive but breathing normally.',
    icon: Icon(Icons.hotel, color: Colors.white, size: 32),
    severity: Severity.stable,
    severityLabel: 'STABLE?',
  ),
  _Condition(
    id: 'snake-bite',
    title: 'SNAKE BITE',
    description: 'Pain, swelling, or other symptoms after a snake bite.',
    icon: Icon(Icons.bug_report, color: Colors.white, size: 32),
    severity: Severity.urgent,
    severityLabel: 'URGENT',
  ),
];

class UrgencyCardsList extends StatelessWidget {
  final void Function(String id)? onSelect;

  const UrgencyCardsList({super.key, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _conditions
          .map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: UrgencyCard(
                title: c.title,
                description: c.description,
                icon: c.icon,
                severity: c.severity,
                severityLabel: c.severityLabel,
                onStart: () => onSelect?.call(c.id),
              ),
            ),
          )
          .toList(),
    );
  }
}