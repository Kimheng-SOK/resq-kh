import 'dart:convert';

import 'package:app/models/notification_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final String _baseUrl = dotenv.env['API_URL']!;

  static Future<List<NotificationModel>> getNotifications() async {
    final response = await http.get(Uri.parse("$_baseUrl/notifications"));

    if (response.statusCode != 200) {
      throw Exception("Failed to load notifications");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }
}
