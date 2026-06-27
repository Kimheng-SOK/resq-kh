import 'dart:convert';
 
import 'package:flutter/services.dart';
 
import 'package:app/models/emergency_contact.dart';
 
class EmergencyRepository {

  List<EmergencyContact>? _cache;
 
  Future<List<EmergencyContact>> getAll() async {
    if (_cache != null) return _cache!;
 
    final jsonString = await rootBundle.loadString('assets/data/contacts.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
 
    _cache = jsonList
        .map((item) => EmergencyContact.fromJson(item as Map<String, dynamic>))
        .toList();
 
    return _cache!;
  }
 
  Future<List<EmergencyContact>> getByType(String type) async {
    final all = await getAll();
    return all.where((c) => c.type == type).toList();
  }
 
  void clearCache() => _cache = null;
}