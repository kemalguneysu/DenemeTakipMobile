import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobil_denemetakip/core/router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;
import 'package:flutter_localizations/flutter_localizations.dart';
Future<void> main()  async{
  //  await dotenv.load(fileName: ".env");
  runApp(
    sh.ShadcnApp(
      theme: sh.ThemeData(
        colorScheme: sh.ColorSchemes.darkZinc(), 
        radius: 0.7,
      ),
      scaling: const sh.AdaptiveScaling(0.9),
      home:  const Uygulama(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        sh.ShadcnLocalizationsDelegate()
      ],
      locale: Locale('tr'),
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en','US')
      ],
    ),
  );
}

sh.ColorScheme _getColorScheme(String theme) {
  if (theme == 'dark') {
    return sh.ColorSchemes.darkZinc(); // Dark tema
  } else {
    return sh.ColorSchemes.lightZinc(); // Light tema
  }
}

class Uygulama extends StatefulWidget {
  const Uygulama({super.key});

  @override
  State<Uygulama> createState() => _UygulamaState();
}

class _UygulamaState extends State<Uygulama> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return MaterialApp.router(
      title: 'Deneme Takip',
      routerConfig: router,
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme,
      ),
    );
  }
}
