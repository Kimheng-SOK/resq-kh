class FirstAidTopicTranslation {
  final String languageCode;
  final String title;
  final String? summary;

  const FirstAidTopicTranslation({
    required this.languageCode,
    required this.title,
    this.summary,
  });

  factory FirstAidTopicTranslation.fromJson(Map<String, dynamic> json) {
    return FirstAidTopicTranslation(
      languageCode: json['language_code'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String?,
    );
  }
}