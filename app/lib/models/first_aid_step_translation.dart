class FirstAidStepTranslation {
  final String languageCode;
  final String instruction;

  const FirstAidStepTranslation({
    required this.languageCode,
    required this.instruction,
  });

  factory FirstAidStepTranslation.fromJson(Map<String, dynamic> json) {
    return FirstAidStepTranslation(
      languageCode: json['language_code'] as String,
      instruction: json['instruction'] as String,
    );
  }
}