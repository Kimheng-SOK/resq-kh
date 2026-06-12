import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'auth_storage_service.dart';

class ContactService {
  static final String baseUrl = dotenv.get(
    'API_BASE_URL',
    fallback: 'http://localhost:3000',
  );

  static Future<List<dynamic>> getContacts() async {
    final userId = await AuthStorageService.getUserId();

    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/contacts'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return json['data'];
    }

    throw Exception('Failed to load contacts');
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

  static Future<void> deleteContact(String contactId) async {
    final userId = await AuthStorageService.getUserId();

    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId/contacts/$contactId'),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete contact');
    }
  }
}
