import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobil_denemetakip/core/router.dart';
import 'package:mobil_denemetakip/services/theme-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;
import 'package:flutter_localizations/flutter_localizations.dart';

sh.ColorScheme colorSchemePreferenceGlobal = sh.ColorSchemes.darkZinc();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeService = ThemeService();
  String? theme = await themeService.getTheme();
  sh.ColorScheme colorSchemePreference = _getColorScheme(theme);
  colorSchemePreferenceGlobal = _getColorScheme(theme);
  runApp(
    MyApp(
      themeService: themeService,
      colorSchemePreference: colorSchemePreferenceGlobal,
    ),
  );
}

sh.ColorScheme _getColorScheme(String? theme) {
  if (theme == 'dark') {
    return sh.ColorSchemes.darkZinc();
  } else {
    return sh.ColorSchemes.lightZinc();
  }
}

class MyApp extends StatelessWidget {
  final ThemeService themeService;
  final sh.ColorScheme colorSchemePreference;

  const MyApp({
    Key? key,
    required this.themeService,
    required this.colorSchemePreference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Uygulama(
      themeService: themeService,
      colorSchemePreference: colorSchemePreference,
    );
  }
}

class Uygulama extends StatefulWidget {
  final ThemeService themeService;
  final sh.ColorScheme colorSchemePreference;

  const Uygulama({
    super.key,
    required this.themeService,
    required this.colorSchemePreference,
  });

  @override
  State<Uygulama> createState() => _UygulamaState();
}

class _UygulamaState extends State<Uygulama> {
  late sh.ColorScheme colorSchemePreference;

  @override
  void initState() {
    super.initState();
    colorSchemePreference = widget.colorSchemePreference;
    widget.themeService.themeNotifier.addListener(() {
      setState(() {
        colorSchemePreference =
            _getColorScheme(widget.themeService.themeNotifier.value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return sh.ShadcnApp.router(
      title: 'Deneme Takip',
      routerConfig: router,
      theme: sh.ThemeData(
        colorScheme: colorSchemePreferenceGlobal,
        radius: 0.7,
      ),
      scaling: const sh.AdaptiveScaling(0.9),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        sh.ShadcnLocalizationsDelegate(),
      ],
      locale: const Locale('en'),
      supportedLocales: const [
        Locale('en', 'US'),
      ],
    );
  }
}
