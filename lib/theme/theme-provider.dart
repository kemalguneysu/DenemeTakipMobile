
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider {
  static const String _themeKey = 'theme';

  static Future<String> getInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'light';
  }

  static Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }

  static ColorScheme getColorScheme(bool isDarkMode) {
    return isDarkMode ? ColorSchemes.darkZinc() : ColorSchemes.lightZinc();
  }
}
