import 'package:app/core/services/country_code.dart';
import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale(CountryCode.EnglishFlag, 'EN'),
    const Locale(CountryCode.CambodianFlag, 'KH'),
    const Locale(CountryCode.ChineseFlag, 'CN'),
    const Locale(CountryCode.FrenchFlag, 'FR'),
  ];
}
