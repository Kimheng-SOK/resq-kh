import 'package:flutter/material.dart';
import 'app.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> testBackend() async {
  try {
    final response = await http.get(
      Uri.parse(
        '${dotenv.get('API_BASE_URL', fallback: 'http://localhost:3000')}/auth/health',
      ),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('ERROR: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await testBackend();
  runApp(const ResQApp());
}
