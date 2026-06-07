import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OsmService {
  static Future<List<dynamic>> searchNearby(double lat, double lon) async {
    final query =
        '''
    [out:json];
    (
      node["amenity"="hospital"](around:3000,$lat,$lon);
      node["amenity"="police"](around:3000,$lat,$lon);
      node["amenity"="fire_station"](around:3000,$lat,$lon);
    );
    out body;
    ''';

    final response = await http.get(
      Uri.parse(
        'https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(query)}',
      ),
      headers: {'User-Agent': 'ResQ-App/1.0', 'Accept': 'application/json'},
    );
    debugPrint('STATUS: ${response.statusCode}');
    debugPrint('BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Overpass API error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    debugPrint(
      '===================================== FOUND: ${data['elements'].length}',
    );

    debugPrint(jsonEncode(data['elements'].take(3).toList()));
    return data['elements'];
  }
}
