import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/first_aid_topic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirstAidApiService {
  static final String _baseUrl = dotenv.env['API_URL']!;

  static Future<List<FirstAidTopic>> fetchTopics({String lang = 'en'}) async {
    final uri = Uri.parse('$_baseUrl/first-aid/topics?lang=$lang');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final data = body['data'];
      if (data == null) {
        return [];
      }
      final List<dynamic> list = data as List<dynamic>;
      return list
          .map((t) => FirstAidTopic.fromJson(t as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load topics: ${response.statusCode}');
  }

  static Future<FirstAidTopic> fetchTopicBySlug(
    String slug, {
    String lang = 'en',
  }) async {
    final uri = Uri.parse('$_baseUrl/first-aid/topics/$slug?lang=$lang');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return FirstAidTopic.fromJson(
        body['data'] as Map<String, dynamic>,
      );
    }
    throw Exception('Failed to load topic "$slug": ${response.statusCode}');
  }
}
