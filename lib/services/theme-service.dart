import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const String _themeKey = 'theme';
  final ValueNotifier<String> themeNotifier = ValueNotifier<String>('light');

  Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme != null) {
      themeNotifier.value = savedTheme;
    }
    return savedTheme;
  }

  Future<void> setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
    themeNotifier.value = theme;
  }
}
