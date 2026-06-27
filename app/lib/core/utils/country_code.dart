class CountryCode {
  static const String EnglishFlag = 'en';
  static const String CambodianFlag = 'km';
  static const String ChineseFlag = 'zh';
  static const String FrenchFlag = 'fr';
  static const String JapaneseFlag = 'ja';

  static String getFlag(String code) {
    switch (code) {
      case EnglishFlag:
        return 'en';
      case CambodianFlag:
        return 'km';
      case ChineseFlag:
        return 'zh';
      case FrenchFlag:
        return 'fr';
      case JapaneseFlag:
        return 'ja';
      default:
        return 'en';
    }
  }

  static String getLanguageName(String code) {
    switch (code) {
      case EnglishFlag:
        return 'English';
      case CambodianFlag:
        return 'ភាសាខ្មែរ';
      case ChineseFlag:
        return '中文';
      case FrenchFlag:
        return 'Français';
      case JapaneseFlag:
        return '日本語';
      default:
        return 'English';
    }
  }
}
