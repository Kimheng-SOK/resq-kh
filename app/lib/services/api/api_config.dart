import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  ApiConfig._();

  static String get baseUrl {
    final configured =
        dotenv.maybeGet('API_BASE_URL') ??
        dotenv.maybeGet('API_URL') ??
        'http://localhost:3000';

    return _normalizeLocalhost(configured);
  }

  static String _normalizeLocalhost(String url) {
    final isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    if (isAndroid) {
      return url
          .replaceFirst('http://localhost', 'http://10.0.2.2')
          .replaceFirst('http://127.0.0.1', 'http://10.0.2.2');
    }

    return url.replaceFirst('http://10.0.2.2', 'http://localhost');
  }
}
