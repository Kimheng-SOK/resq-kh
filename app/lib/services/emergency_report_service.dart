import 'dart:convert';
import 'package:http/http.dart' as http;

class EmergencyReportService {
  static const String _baseUrl = 'http://localhost:3000';

  static Future<void> submitReport({
    required String incidentTypeId,
    required String name,
    required String phone,
    required String description,
    double? lat,
    double? lng,
  }) async {
    final uri = Uri.parse('$_baseUrl/emergency-reports');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'incident_type_id': incidentTypeId,
        'reporter_name': name,
        'reporter_phone': phone,
        'description': description,
        'latitude': lat,
        'longitude': lng,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to submit report: ${response.statusCode}');
    }
  }
}