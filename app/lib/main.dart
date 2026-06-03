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

  runApp(const ResQApp());
}
