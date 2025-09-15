import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('hi');
    } else if (_locale.languageCode == 'hi') {
      _locale = const Locale('bn');
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }
}