import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app/models/incident_type_model.dart';

class IncidentTypeService {
  static final String _baseUrl = dotenv.env['API_URL']!;

  static Future<List<IncidentType>> fetchAll() async {
    final uri = Uri.parse('$_baseUrl/incident-types');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final data = body['data'];
      if (data == null) {
        return [];
      }
      final List<dynamic> list = data as List<dynamic>;
      return list.map((i) => IncidentType.fromJson(i)).toList();
    }
    throw Exception('Failed to load incident types: ${response.statusCode}');
  }
}
