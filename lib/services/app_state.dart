import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  Locale _locale = Locale('es');

  Locale get locale => _locale;

  void changeLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }

  void toggleLanguage() {
    _locale = _locale.languageCode == 'es' ? Locale('en') : Locale('es');
    notifyListeners();
  }
}
