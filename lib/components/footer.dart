import 'package:go_router/go_router.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/main.dart';
import 'package:mobil_denemetakip/services/auth-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int selected = 0;

  NavigationBarAlignment alignment = NavigationBarAlignment.spaceAround;
  bool expands = false; // Sonsuz boyut hatasını önlemek için false yaptık.
  bool customButtonStyle = true;

  NavigationButton buildButton(String label, IconData icon,String route) {
    return NavigationButton(
      style: const ButtonStyle.muted(density: ButtonDensity.icon),
      selectedStyle: const ButtonStyle.fixed(density: ButtonDensity.icon),
      label: Text(label,style: TextStyle(fontSize: 16)),
      child: Icon(icon,size: 24,),
      onChanged: (bool selected){
        if(selected)
          context.go(route);
      },
    );
  }

   @override
  Widget build(BuildContext context) {
    // AuthService'ı context üzerinden alıyoruz
    final authService = AuthService();

    return StreamBuilder<Map<String, dynamic>>(
      stream: authService.authStatusStream, // AuthService'den stream alıyoruz
      builder: (context, snapshot) {
        // Eğer snapshot verisi yoksa veya henüz yüklenmediyse boş ekran göster
        if (!snapshot.hasData) {
          return Container();
        }

        var userStatus = snapshot.data!;

        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Yalnızca içeriği kadar yer kapla.
            children: [
              const Divider(),
              NavigationBar(
                backgroundColor: Theme.of(context).colorScheme.background,
                alignment: alignment,
                labelType: NavigationLabelType.none,
                expands: false,
                children: [
                  buildButton('Ana Sayfa', BootstrapIcons.house, "/"),

                  // Eğer kullanıcı giriş yapmışsa, 'Giriş Yap' butonunu çıkış butonuna çevir
                  userStatus['isAuthenticated']
                      ? NavigationButton(
                          style: const ButtonStyle.muted(
                              density: ButtonDensity.icon),
                          selectedStyle: const ButtonStyle.fixed(
                              density: ButtonDensity.icon),
                          label: const Text('Çıkış Yap',
                              style: TextStyle(fontSize: 16)),
                          child: const Icon(Icons.exit_to_app, size: 24),
                          onChanged: (bool selected) async {
                            if (selected) {
                              await authService.signOut(); 
                              context.go("/giris-yap"); 
                              successToast("Oturum kapatıldı", "Başarıyla çıkış yapıldı.", context);
                            }
                          },
                        )
                      : buildButton(
                          'Giriş Yap', BootstrapIcons.person, "/giris-yap"),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
