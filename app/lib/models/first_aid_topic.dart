import 'package:app/models/first_aid_step.dart';
import 'package:app/models/first_aid_topic_translation.dart';

class FirstAidTopic {
  final String id;
  final String slug;
  final String? iconName;
  final int sortOrder;
  final String severity;
  final List<FirstAidTopicTranslation> translations;
  final List<FirstAidStep> steps;

  const FirstAidTopic({
    required this.id,
    required this.slug,
    this.iconName,
    required this.sortOrder,
    required this.severity,
    required this.translations,
    this.steps = const [],
  });

  factory FirstAidTopic.fromJson(Map<String, dynamic> json) {
    return FirstAidTopic(
      id: json['id'] as String,
      slug: json['slug'] as String,
      iconName: json['icon_name'] as String?,
      sortOrder: json['sort_order'] as int,
      severity: json['severity'] as String,
      translations: (json['translations'] as List<dynamic>)
          .map((t) => FirstAidTopicTranslation.fromJson(t as Map<String, dynamic>))
          .toList(),
      steps: json['steps'] != null
          ? (json['steps'] as List<dynamic>)
              .map((s) => FirstAidStep.fromJson(s as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}