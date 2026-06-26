import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/incident_type_model.dart';

class IncidentTypeService {
  static const String _baseUrl = 'http://localhost:3000';

  static Future<List<IncidentType>> fetchAll() async {
    final uri = Uri.parse('$_baseUrl/incident-types');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> list = body['data'] as List<dynamic>;
      return list.map((i) => IncidentType.fromJson(i)).toList();
    }
    throw Exception('Failed to load incident types: ${response.statusCode}');
  }
}