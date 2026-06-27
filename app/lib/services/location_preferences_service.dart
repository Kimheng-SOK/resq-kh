import 'package:shared_preferences/shared_preferences.dart';

class LocationPreferencesService {
  static const String _radiusKey = 'nearby_radius_km';

  static Future<void> saveRadius(double radius) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_radiusKey, radius);
  }

  static Future<double> getRadius() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_radiusKey) ?? 5.0;
  }
}
