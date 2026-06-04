import 'dart:convert';

import 'package:app/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserService {
  static final String baseUrl = dotenv.get('API_BASE_URL');

  static Future<Map<String, dynamic>> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('User Profile Response Status: ${response.statusCode}');
    print('User Profile Response Body: ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to fetch user profile');
  }

  static Future<void> deleteAccount(String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Delete Account Response Status: ${response.statusCode}');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete account');
    }
  }
}
