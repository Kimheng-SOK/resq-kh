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
  /// Returns true on success, throws on failure.
  static Future<bool> sendOtp({
    required String fullName,
    required String email,
    required String phoneNumber,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to send OTP (${response.statusCode})');
    }

    return true;
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
