import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../models/emergency_contact.dart';

class ServicesApiService {
  static final String baseUrl = dotenv.get(
    'API_BASE_URL',
    fallback: 'http://localhost:3000',
  );

  static dynamic _unwrap(Map<String, dynamic> response) {
    if (response.containsKey('data')) {
      return response['data'];
    }
    return response;
  }

  static Future<List<EmergencyContact>> fetchServices({
    String? category,
    double? lat,
    double? lng,
    double radius = 50,
  }) async {
    final queryParams = <String, String>{};
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (lat != null && lng != null) {
      queryParams['lat'] = lat.toString();
      queryParams['lng'] = lng.toString();
      queryParams['radius'] = radius.toString();
    }

    final uri = Uri.parse(
      '$baseUrl/services',
    ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch services (${response.statusCode})');
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;
    final data = _unwrap(decoded);

    if (data is List) {
      return data
          .map(
            (item) =>
                EmergencyContact.fromServiceJson(item as Map<String, dynamic>),
          )
          .toList();
    }

    throw Exception('Unexpected response format from /services');
  }

  /// Fetches a single service by ID.
  static Future<EmergencyContact> fetchServiceById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/services/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch service $id (${response.statusCode})');
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;
    final data = _unwrap(decoded);

    return EmergencyContact.fromServiceJson(data as Map<String, dynamic>);
  }
}
