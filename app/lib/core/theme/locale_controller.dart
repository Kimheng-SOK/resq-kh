import 'package:flutter/material.dart';
import 'package:app/services/storage_service.dart';
import 'package:app/core/utils/country_code.dart';

class LocaleController extends ChangeNotifier {
  Locale _locale = const Locale(CountryCode.EnglishFlag);

  Locale get locale => _locale;

  /// Maps a language code string to a [Locale] object.
  static Locale localeFromCode(String code) {
    switch (code) {
      case CountryCode.EnglishFlag:
        return const Locale(CountryCode.EnglishFlag);
      case CountryCode.CambodianFlag:
        return const Locale(CountryCode.CambodianFlag);
      case CountryCode.ChineseFlag:
        return const Locale(CountryCode.ChineseFlag);
      case CountryCode.FrenchFlag:
        return const Locale(CountryCode.FrenchFlag);
      case CountryCode.JapaneseFlag:
        return const Locale(CountryCode.JapaneseFlag);
      default:
        return const Locale(CountryCode.EnglishFlag);
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await StorageService.setLanguage(locale.languageCode);
    notifyListeners();
  }

  Future<void> loadLocale() async {
    final code = await StorageService.getLanguage();
    _locale = localeFromCode(code);
    notifyListeners();
  }
}
