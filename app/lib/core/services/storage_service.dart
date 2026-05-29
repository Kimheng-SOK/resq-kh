import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/emergency_contact.dart';

/// Local storage service for emergency contacts using SharedPreferences
class StorageService {
  static const _contactsKey = 'emergency_contacts';
  static const _settingsKey = 'user_settings';

  // ---------- Emergency Contacts ----------

  /// Load all saved emergency contacts
  static Future<List<EmergencyContact>> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_contactsKey);
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list
          .map((e) => EmergencyContact.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Save full contact list
  static Future<void> saveContacts(List<EmergencyContact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString =
        jsonEncode(contacts.map((c) => c.toJson()).toList());
    await prefs.setString(_contactsKey, jsonString);
  }

  /// Add a single contact
  static Future<void> addContact(EmergencyContact contact) async {
    final contacts = await loadContacts();
    contacts.add(contact);
    await saveContacts(contacts);
  }

  /// Update an existing contact by ID
  static Future<void> updateContact(EmergencyContact updated) async {
    final contacts = await loadContacts();
    final index = contacts.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      contacts[index] = updated;
      await saveContacts(contacts);
    }
  }

  /// Delete a contact by ID
  static Future<void> deleteContact(String id) async {
    final contacts = await loadContacts();
    contacts.removeWhere((c) => c.id == id);
    await saveContacts(contacts);
  }

  // ---------- User Settings ----------

  /// Save a simple key-value setting
  static Future<void> setSetting(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_settingsKey.$key', value);
  }

  /// Get a setting value
  static Future<String?> getSetting(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_settingsKey.$key');
  }

  // Convenience methods for known settings
  static Future<String> getLanguage() async =>
      (await getSetting('language')) ?? 'EN';

  static Future<void> setLanguage(String lang) async =>
      setSetting('language', lang);

  static Future<bool> getDarkMode() async {
    final val = await getSetting('darkMode');
    return val == 'true';
  }

  static Future<void> setDarkMode(bool value) async =>
      setSetting('darkMode', value.toString());

  static Future<String> getBloodGroup() async =>
      (await getSetting('bloodGroup')) ?? '';

  static Future<void> setBloodGroup(String value) async =>
      setSetting('bloodGroup', value);

  static Future<String> getAllergies() async =>
      (await getSetting('allergies')) ?? '';

  static Future<void> setAllergies(String value) async =>
      setSetting('allergies', value);
}
