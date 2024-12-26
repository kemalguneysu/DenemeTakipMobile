import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;

class ThemeProvider extends ChangeNotifier {
  sh.ColorScheme _colorScheme = sh.ColorSchemes.lightZinc();
  String _theme = 'light';

  sh.ColorScheme get colorScheme => _colorScheme;
  String get theme => _theme;

  void setTheme(String newTheme) {
    _theme = newTheme;
    _colorScheme = newTheme == 'light'
        ? sh.ColorSchemes.lightZinc()
        : sh.ColorSchemes.darkZinc();
    notifyListeners(); 
  }
}
