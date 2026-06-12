import 'package:app/core/services/storage_service.dart';
import 'package:app/core/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefreshService {
  RefreshService._();

  static Future<void> refreshPreferences(BuildContext context) async {
    final controller = context.read<ThemeController>();
    await controller.loadThemeMode();
    // Note: language is reloaded directly by PreferenceScreen after refresh.
  }

  static Future<void> refreshSettings(BuildContext context) async {
    await StorageService.getThemeMode();
    await StorageService.getLanguage();
    // Extend with additional persisted settings as they are added.
  }

  static Future<void> refreshContacts() async {
    // TODO: replace with actual contact-reload logic.
    await Future.delayed(const Duration(milliseconds: 600));
  }

  /// Reloads home-screen data — SOS status, quick actions, etc.
  static Future<void> refreshHome() async {
    // TODO: replace with actual home-data reload.
    await Future.delayed(const Duration(milliseconds: 600));
  }

  /// Convenience — reloads everything (preferences + contacts + home).
  static Future<void> refreshAll(BuildContext context) async {
    await refreshPreferences(context);
    await refreshContacts();
    await refreshHome();
  }
}
