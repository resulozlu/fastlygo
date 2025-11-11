import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class LanguageProvider with ChangeNotifier {
  final SharedPreferences _prefs;
  Locale _locale = const Locale('en', '');

  LanguageProvider(this._prefs) {
    _loadLanguage();
  }

  Locale get locale => _locale;

  String get languageCode => _locale.languageCode;

  String get currencySymbol {
    return AppConstants.currencySymbols[_locale.languageCode] ?? '\$';
  }

  String get currencyCode {
    return AppConstants.currencyCodes[_locale.languageCode] ?? 'USD';
  }

  Future<void> _loadLanguage() async {
    final languageCode = _prefs.getString(AppConstants.keyLanguage);
    if (languageCode != null) {
      _locale = Locale(languageCode, '');
      notifyListeners();
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode == _locale.languageCode) return;
    
    _locale = Locale(languageCode, '');
    await _prefs.setString(AppConstants.keyLanguage, languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (locale == _locale) return;
    
    _locale = locale;
    await _prefs.setString(AppConstants.keyLanguage, locale.languageCode);
    notifyListeners();
  }

  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      case 'mk':
        return 'Македонски';
      default:
        return 'English';
    }
  }

  List<Map<String, String>> get supportedLanguages => [
        {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
        {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
        {'code': 'mk', 'name': 'Македонски', 'flag': '🇲🇰'},
      ];
}
