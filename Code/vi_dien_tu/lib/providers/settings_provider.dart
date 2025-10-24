import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _isEnglish = false;

  bool get isDarkMode => _isDarkMode;
  bool get isEnglish => _isEnglish;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void toggleLanguage() {
    _isEnglish = !_isEnglish;
    notifyListeners();
  }
}
