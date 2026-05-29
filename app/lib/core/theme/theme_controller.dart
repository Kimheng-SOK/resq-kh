import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Reactive theme controller — persists preference and notifies listeners.
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  /// Load saved preference from storage (call once at startup).
  Future<void> load() async {
    final dark = await StorageService.getDarkMode();
    _mode = dark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Toggle between light and dark.
  Future<void> toggle() async {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await StorageService.setDarkMode(_mode == ThemeMode.dark);
    notifyListeners();
  }

  /// Set a specific mode.
  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    await StorageService.setDarkMode(mode == ThemeMode.dark);
    notifyListeners();
  }
}
