import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/first_aid_provider.dart';
import 'urgency_card.dart';

// Maps icon_name from database to Flutter IconData
IconData _iconForName(String? iconName) {
  switch (iconName) {
    case 'heart':   return Icons.favorite;
    case 'warning': return Icons.warning_amber_rounded;
    case 'fire':    return Icons.local_fire_department;
    case 'blood':   return Icons.water_drop;
    case 'bone':    return Icons.accessibility_new;
    default:        return Icons.medical_services;
  }
}

// Maps severity string from database to Severity enum
Severity _parseSeverity(String? severity) {
  switch (severity) {
    case 'critical': return Severity.critical;
    case 'urgent':   return Severity.urgent;
    default:         return Severity.stable;
  }
}

class UrgencyCardsList extends ConsumerWidget {
  final void Function(String slug)? onSelect;

  const UrgencyCardsList({super.key, this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(firstAidProvider);

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFAF101A)),
      );
    }

    if (state.error != null) {
      return Center(
        child: Text(
          'Failed to load: ${state.error}',
          style: const TextStyle(color: Color(0xFFAF101A)),
        ),
      );
    }

    if (state.topics.isEmpty) {
      return const Center(child: Text('No conditions available.'));
    }

    return Column(
      children: state.topics.map((topic) {
        final translation = topic.translations.isNotEmpty
            ? topic.translations.first
            : null;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: UrgencyCard(
            title: (translation?.title ?? topic.slug).toUpperCase(),
            description: translation?.summary ?? '',
            icon: Icon(
              _iconForName(topic.iconName),
              color: Colors.white,
              size: 32,
            ),
            severity: _parseSeverity(topic.severity),
            //severityLabel: (topic.severity ?? 'stable').toUpperCase(),
            onStart: () => onSelect?.call(topic.slug),
          ),
        );
      }).toList(),
    );
  }
}