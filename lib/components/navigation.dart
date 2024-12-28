import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/core/router.dart';
import 'package:mobil_denemetakip/main.dart';
import 'package:mobil_denemetakip/services/theme-provider.dart';
import 'package:mobil_denemetakip/services/theme-service.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class NavigationHeader extends StatefulWidget {

  const NavigationHeader({Key? key,})
      : super(key: key);

  @override
  _NavigationHeaderState createState() => _NavigationHeaderState();
}

class _NavigationHeaderState extends State<NavigationHeader> {
  bool isLightTheme = true;

  @override
  void initState() {
    final themeService = ThemeService();
    super.initState();
    _loadTheme();
    themeService.themeNotifier.addListener(() {
      if (mounted) {
        setState(() {
          isLightTheme = themeService.themeNotifier.value == 'light';
        });
      }
    });
  }

  void _loadTheme() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    String? theme = await themeService.getTheme();
    setState(() {
      isLightTheme = themeProvider.theme == 'light';
    });
  }

  void _toggleTheme() {
    setState(() {
      isLightTheme = !isLightTheme;
    });
    themeService.setTheme(isLightTheme ? 'light' : 'dark');
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.setTheme(isLightTheme ? 'light' : 'dark');
  }

  void open(BuildContext context) {
    openDrawer(
      context: context,
      expands: true,
      builder: (context) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            children: [
              // Üst kısım
              Expanded(
                flex: 1, // 1 birimlik alan
                child: Container(),
              ),
              // Orta kısım
              Expanded(
                flex: 3, // 3 birimlik alan
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Eşit yayılma
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Ortalamak için
                  children: [
                    Button.link(
                      onPressed: () {
                        context.go('/denemelerim');
                      },
                      child: const Text(
                        'Denemelerim',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Button.link(
                      onPressed: () {
                        context.go('/analizlerim');
                      },
                      child: const Text(
                        'Analizler',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Button.link(
                      onPressed: () {
                        context.go('/konu-takip');
                      },
                      child: const Text(
                        'Konu Takip',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Button.link(
                      onPressed: () {
                        context.go('/yapilacaklar');
                      },
                      child: const Text(
                        'Yapılacaklar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Button.link(
                      onPressed: () {
                        context.go('/notlarim');
                      },
                      child: const Text(
                        'Notlarım',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Button.link(
                      onPressed: () {
                        context.go('/pomodoro');
                      },
                      child: const Text(
                        'Pomodoro',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1, // 1 birimlik alan
                child: Container(),
              ),
            ],
          ),
        );
      },
      position: OverlayPosition.left,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.zero,
      child: NavigationMenu(
        children: [
          NavigationItem(
            onPressed: () {
              context.go('/');
            },
            child: const Text(
              'Deneme Takip',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      trailing: [
        GhostButton(
          density: ButtonDensity.icon,
          onPressed: () {
            _toggleTheme();
          },
          child: isLightTheme ? Icon(LucideIcons.moon) : Icon(LucideIcons.sun),
          size: ButtonSize(1.2),
        ),
        GhostButton(
          density: ButtonDensity.icon,
          onPressed: () {
            open(context);
          },
          child: const Icon(LucideIcons.menu),
          size: ButtonSize(1.2),
        ),
      ],
    );
  }
}
