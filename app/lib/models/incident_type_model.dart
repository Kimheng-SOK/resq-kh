class IncidentType {
  final String id;
  final String slug;
  final String label;
  final String iconName;
  final String? recommendedResponder;

  const IncidentType({
    required this.id,
    required this.slug,
    required this.label,
    required this.iconName,
    this.recommendedResponder,
  });

  factory IncidentType.fromJson(Map<String, dynamic> json) {
    return IncidentType(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      label: json['label'] as String? ?? 'Unknown',
      iconName: json['icon_name'] as String? ?? 'warning',
      recommendedResponder: json['recommended_responder'] as String?,
    );
  }
}