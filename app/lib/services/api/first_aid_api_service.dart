import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/first_aid_topic.dart';

class FirstAidApiService {
  static const String _baseUrl = 'http://localhost:3000';

  static Future<List<FirstAidTopic>> fetchTopics({String lang = 'en'}) async {
    final uri = Uri.parse('$_baseUrl/first-aid/topics?lang=$lang');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> list = body['data'] as List<dynamic>;  // ← unwrap data
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
          body['data'] as Map<String, dynamic>);  // ← unwrap data
    }
    throw Exception('Failed to load topic "$slug": ${response.statusCode}');
  }
}