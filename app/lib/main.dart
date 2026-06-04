import 'package:app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'package:http/http.dart' as http;

Future<void> testBackend() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/auth/health'),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('ERROR: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await testBackend();

  final token = await AuthService.getToken();

  final initialRoute = token != null ? '/' : '/splash';

  runApp(ResQApp(initialRoute: initialRoute));
}
