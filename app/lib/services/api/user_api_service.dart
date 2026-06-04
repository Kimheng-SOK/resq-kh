import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Pure HTTP service for user-related API calls.
/// Throws raw exceptions — callers are responsible for handling them.
class UserApiService {
  static final String baseUrl = dotenv.get('API_BASE_URL');

  /// Fetches the authenticated user's profile.
  /// Returns the raw JSON response map on success, throws on failure.
  static Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch user profile (${response.statusCode})',
      );
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }

  /// Deletes the authenticated user's account.
  /// Throws on failure.
  static Future<void> deleteAccount(String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete account (${response.statusCode})');
    }
  }
}
