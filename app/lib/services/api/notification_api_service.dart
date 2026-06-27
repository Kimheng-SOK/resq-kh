import 'dart:convert';

import 'package:app/models/notification_model.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class NotificationService {
  static String get baseUrl => ApiConfig.baseUrl;

  static Future<List<NotificationModel>> getNotifications() async {
    final response = await http.get(Uri.parse("$baseUrl/notifications"));

    if (response.statusCode != 200) {
      throw Exception("Failed to load notifications");
    }

    final List data = jsonDecode(response.body);

    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }
}
