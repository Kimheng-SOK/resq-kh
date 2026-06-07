import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  static Future<List<dynamic>> getContacts(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/contacts'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load contacts');
  }

  static Future<void> addContact({
    required String userId,
    required String name,
    required String phoneNumber,
    required String relationship,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/$userId/contacts'),
      headers: {'Content-Type': 'application/json'},
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

  static Future<void> deleteContact({
    required String userId,
    required String contactId,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId/contacts/$contactId'),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete contact');
    }
  }

  static Future<void> updateContact({
    required String userId,
    required String contactId,
    required String name,
    required String phoneNumber,
    required String relationship,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/users/$userId/contacts/$contactId'),
      headers: {'Content-Type': 'application/json'},
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
}
