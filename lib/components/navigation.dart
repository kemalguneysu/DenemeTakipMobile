
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationHeader extends StatefulWidget  {
  const NavigationHeader({Key? key}) : super(key: key);
   @override
  _NavigationHeaderState createState() => _NavigationHeaderState();
}
class _NavigationHeaderState extends State<NavigationHeader> {
  bool isLightTheme=true;
  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Başlangıçta temayı yükle
  }
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme') ?? 'light';
    setState(() {
      isLightTheme = theme == 'light';
    });
  }
  Future<void> _updateThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final newTheme = isLightTheme ? 'dark' : 'light'; 
    await prefs.setString('theme', newTheme);
  }
  void _toggleTheme() {
    setState(() {
      isLightTheme = !isLightTheme; // Durumu değiştir
    });
    _updateThemePreference(); // Yeni durumu kaydet
  }
  void open(BuildContext context) {
    openDrawer(
      context: context,
      expands: true,
      builder: (context) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          alignment: Alignment.center,
          padding:
              const EdgeInsets.symmetric(horizontal: 4), 
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
                            fontSize: 18, fontWeight: FontWeight.bold,
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
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Button.link(
                      onPressed: () {
                        context.go('/konu-takip');
                      },
                      child: const Text(
                        'Konu Takip',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Button.link(
                      onPressed: () {
                        context.go('/yapilacaklar');
                      },
                      child: const Text(
                        'Yapılacaklar',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Button.link(
                      onPressed: () {
                        context.go('/notlarim');
                      },
                      child: const Text(
                        'Notlarım',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Button.link(
                      onPressed: () {
                        context.go('/pomodoro');
                      },
                      child: const Text(
                        'Pomodoro',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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

  
  
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      padding: EdgeInsets.zero,
      child:NavigationMenu(
        children: [
          NavigationItem(
          onPressed: () {},
          child: const Text('Deneme Takip',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600,),),
          ),
        ]
      ),
      trailing: [
        GhostButton(
          density: ButtonDensity.icon,
          onPressed: (){
             _toggleTheme();
          },
          child: isLightTheme? Icon(Icons.sunny) :Icon(Icons.bedtime),
          size: ButtonSize(1.2),
        ),
        GhostButton(
          density: ButtonDensity.icon,
          onPressed: () {
            open(context);
          },
          child: const Icon(Icons.menu),
          size:ButtonSize(1.2),
          
        ),
      ],

    );
    
  }
}
