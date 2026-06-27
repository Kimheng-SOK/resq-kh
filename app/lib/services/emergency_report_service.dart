import 'dart:convert';

import 'package:app/models/emergency_report_model.dart';
import 'package:app/services/auth_storage_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EmergencyReportService {
  static final String _baseUrl = dotenv.env['API_URL']!;

  /// -------------------------
  /// Submit Emergency Report
  /// -------------------------
  static Future<void> submitReport({
    required String incidentTypeId,
    required String name,
    required String phone,
    required String description,
    double? lat,
    double? lng,
  }) async {
    final userId = await AuthStorageService.getUserId();

    if (userId == null) {
      throw Exception('You must be logged in to submit a report.');
    }

    final uri = Uri.parse('$_baseUrl/emergency-reports');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'incident_type_id': incidentTypeId,
        'reporter_name': name,
        'reporter_phone': phone,
        'description': description,
        'latitude': lat,
        'longitude': lng,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.body);
    }
  }

  /// -------------------------
  /// Get Current User Reports
  /// -------------------------
  static Future<List<EmergencyReport>> getMyReports() async {
    final userId = await AuthStorageService.getUserId();

    if (userId == null) {
      return []; // Not logged in or user ID not saved yet — no reports to show
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/emergency-reports/user/$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load reports');
    }

    final json = jsonDecode(response.body);

    final data = json['data'];
    if (data == null) {
      return [];
    }

    final List reports = data as List;

    return reports.map((e) => EmergencyReport.fromJson(e)).toList();
  }
}
