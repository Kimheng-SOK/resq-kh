import 'package:app/models/first_aid_step_translation.dart';

class FirstAidStep {
  final String id;
  final int stepNumber;
  final bool isWarning;
  final String? imageUrl;
  final List<FirstAidStepTranslation> translations;

  const FirstAidStep({
    required this.id,
    required this.stepNumber,
    required this.isWarning,
    this.imageUrl,
    required this.translations,
  });

  factory FirstAidStep.fromJson(Map<String, dynamic> json) {
    return FirstAidStep(
      id: json['id'] as String,
      stepNumber: json['step_number'] as int,
      isWarning: json['is_warning'] as bool,
      imageUrl: json['image_url'] as String?,
      translations: (json['translations'] as List<dynamic>)
          .map((t) => FirstAidStepTranslation.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }
}