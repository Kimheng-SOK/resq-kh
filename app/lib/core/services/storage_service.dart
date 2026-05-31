import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final _settingsKey = 'user_settings';

  static Future<void> setSettings(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_settingsKey.$key', value);
  }

  static Future<String?> getSettings(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_settingsKey.$key');
  }

  static Future<String> getThemeMode() async {
    return await getSettings('themeMode') ?? 'system';
  }

  static Future<void> setThemeMode(String mode) async =>
      await setSettings('themeMode', mode);

  static Future<String> getLanguage() async {
    return await getSettings('language') ?? 'EN';
  }

  static Future<void> setLanguage(String language) async =>
      await setSettings('language', language);
}
