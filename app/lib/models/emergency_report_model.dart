class EmergencyReport {
  final String id;
  final String reporterName;
  final String reporterPhone;
  final String description;
  final String status;
  final String incidentType;
  final DateTime createdAt;

  EmergencyReport({
    required this.id,
    required this.reporterName,
    required this.reporterPhone,
    required this.description,
    required this.status,
    required this.incidentType,
    required this.createdAt,
  });

  factory EmergencyReport.fromJson(Map<String, dynamic> json) {
    return EmergencyReport(
      id: json['id'],
      reporterName: json['reporter_name'],
      reporterPhone: json['reporter_phone'],
      description: json['description'] ?? '',
      status: json['status'],
      incidentType: json['incidentType']['label'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
