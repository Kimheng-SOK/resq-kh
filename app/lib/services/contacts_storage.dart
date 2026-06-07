import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/models/contact_model.dart';

class ContactsStorage {
  static const String contactsKey = 'contacts';

  static Future<void> saveContacts(List<Contact> contacts) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = contacts.map((c) => c.toJson()).toList();

    await prefs.setString(contactsKey, jsonEncode(jsonList));
  }

  static Future<List<Contact>> loadContacts() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(contactsKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded.map((item) => Contact.fromJson(item)).toList();
  }
}
