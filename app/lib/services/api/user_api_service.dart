import 'dart:convert';
import 'package:app/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserApiService {
  static final String baseUrl = dotenv.get('API_BASE_URL');

  /// Helper: the backend TransformInterceptor wraps all responses in
  /// `{ statusCode, message, data: {...} }`.  Extract the inner payload.
  static Map<String, dynamic> _unwrap(Map<String, dynamic> response) {
    if (response.containsKey('data') && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response;
  }

  static Future<UserModel> fetchUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user profile (${response.statusCode})');
    }
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    return UserModel.fromJson(_unwrap(decoded));
  }

  static Future<UserModel> updateProfile({
    required String token,
    String? fullName,
    String? phoneNumber,
    String? bloodGroup,
    String? allergies,
    String? medicalConditions,
    String? preferredLanguage,
    bool? darkModeEnabled,
  }) async {
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (phoneNumber != null) body['phone_number'] = phoneNumber;
    if (bloodGroup != null) body['blood_group'] = bloodGroup;
    if (allergies != null) body['allergies'] = allergies;
    if (medicalConditions != null) body['medical_conditions'] = medicalConditions;
    if (preferredLanguage != null) body['preferred_language'] = preferredLanguage;
    if (darkModeEnabled != null) body['dark_mode_enabled'] = darkModeEnabled;

    final response = await http.patch(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile (${response.statusCode})');
    }
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    return UserModel.fromJson(_unwrap(decoded));
  }

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
