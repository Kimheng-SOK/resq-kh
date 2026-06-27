import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../auth_storage_service.dart';

class ContactService {
  static String get baseUrl => ApiConfig.baseUrl;

  static Future<Map<String, String>> _headers() async {
    final headers = {'Content-Type': 'application/json'};
    final token = await AuthStorageService.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  static List<dynamic> parseContactsPayload(String body) {
    final decoded = jsonDecode(body);

    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      final data = decoded['data'];
      if (data is List) {
        return data;
      }
    }

    throw Exception('Unexpected contacts response format');
  }

  static Future<List<dynamic>> getContacts() async {
    final userId = await AuthStorageService.getUserId();

    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/contacts'),
      headers: await _headers(),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load contacts (${response.statusCode})');
    }

    return parseContactsPayload(response.body);
  }

  static Future<void> addContact({
    required String name,
    required String phoneNumber,
    required String relationship,
  }) async {
    final userId = await AuthStorageService.getUserId();

    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/contacts'),
      headers: await _headers(),
      body: jsonEncode({
        'name': name,
        'phone_number': phoneNumber,
        'relationship': relationship,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to add contact');
    }
  }

  static Future<void> updateContact({
    required String contactId,
    required String name,
    required String phoneNumber,
    required String relationship,
  }) async {
    final userId = await AuthStorageService.getUserId();

    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/users/$userId/contacts/$contactId'),
      headers: await _headers(),
      body: jsonEncode({
        'name': name,
        'phone_number': phoneNumber,
        'relationship': relationship,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update contact');
    }
  }

  static Future<void> deleteContact(String contactId) async {
    final userId = await AuthStorageService.getUserId();

    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId/contacts/$contactId'),
      headers: await _headers(),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete contact');
    }
  }
}
