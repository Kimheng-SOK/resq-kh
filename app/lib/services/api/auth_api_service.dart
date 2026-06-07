import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Pure HTTP service for authentication API calls.
/// Throws raw exceptions — callers are responsible for handling them.
class AuthApiService {
  static final String baseUrl = dotenv.get(
    'API_BASE_URL',
    fallback: 'http://localhost:3000',
  );

  /// Sends an OTP to the given phone number.
  /// [email] is optional — pass `null` or omit if the user didn't provide one.
  /// Returns true on success, throws on failure.
  static Future<bool> sendOtp({
    required String fullName,
    String? email,
    required String phoneNumber,
  }) async {
    final body = <String, dynamic>{
      'full_name': fullName,
      'phone_number': phoneNumber,
    };
    // Only include email if it was provided
    if (email != null && email.isNotEmpty) {
      body['email'] = email;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to send OTP (${response.statusCode})');
    }

    return true;
  }

  /// Validates whether a stored token is still accepted by the backend.
  /// Returns `true` if the token is valid, `false` otherwise.
  /// Does NOT throw — meant for silent validation checks.
  static Future<bool> validateToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/health'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (_) {
      // Network error — assume token is still valid (offline support)
      return true;
    }
  }

  /// Verifies the OTP for the given phone number.
  /// Returns the raw JSON response map on success, throws on failure.
  static Future<Map<String, dynamic>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone_number': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('OTP verification failed (${response.statusCode})');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
