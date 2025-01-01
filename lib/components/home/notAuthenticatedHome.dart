import 'dart:math';

import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/spinner.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/deneme-service.dart';
import 'package:mobil_denemetakip/services/dersler-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class NotAuthenticatedHome extends StatefulWidget {
  const NotAuthenticatedHome({super.key});

  @override
  State<NotAuthenticatedHome> createState() => _NotAuthenticatedHomeState();
}

class _NotAuthenticatedHomeState extends State<NotAuthenticatedHome> {
  final List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'image': '/images/yks-tyt-ayt-denemeler.webp',
      'title': 'Deneme Takip',
      'description':
          'TYT ve AYT denemelerini düzenli olarak kaydet ve sıralama yap. Netlerini tarihe veya net sayısına göre incele.',
    },
    {
      'id': 2,
      'image': '/images/yks-tyt-ayt-denemeler-analiz.webp',
      'title': 'Deneme Analiz',
      'description':
          'Deneme sonuçlarını grafiklerle analiz et. Genel netlerini ya da ders bazındaki performansını incele. En çok yanlış veya boş yaptığın konuları görüp çalışmalarını düzenle.',
    },
    {
      'id': 3,
      'image': '/images/yks-tyt-ayt-pomodoro.webp',
      'title': 'Pomodoro',
      'description':
          'Çalışma odaklanmanızı artırmak için Pomodoro tekniğini kullanın. Hızlı oturumlar ile sabit süreli oturumlar yapabilir veya özelleştirilmiş süreler ile oturumlarınızı dilediğiniz gibi ayarlayabilirsiniz. Ayrıca, favori Spotify çalma listenizi veya YouTube videonuzu ekleyerek motivasyonunuzu artırabilirsiniz.',
    },
    {
      'id': 4,
      'image': '/images/yks-tyt-ayt-konu-takip.webp',
      'title': 'Konu Takip',
      'description':
          'Tamamladığın konuları işaretle, tamamladıklarını yüzdelik ve sayısal olarak takip et. Eksik konuları belirleyerek çalışmalarını daha planlı hale getir.',
    },
    {
      'id': 5,
      'image': '/images/yks-tyt-ayt-planlama.webp',
      'title': 'Planlama',
      'description':
          'Aylık ve haftalık planlar oluştur. Günlerini detaylı bir şekilde düzenle ve takip et. Etkili planlama ile hedeflerine daha hızlı ulaş.',
    },
    {
      'id': 6,
      'image': '/images/yks-tyt-ayt-notlar.webp',
      'title': 'Notlar',
      'description':
          'Ders çalışırken notlarını kolayca kaydet ve düzenle. Klasörleme sistemi ile notlarına istediğin zaman ulaş. Konularını organize ederek YKS hazırlığını daha verimli hale getir.',
    },
  ];

  final CarouselController controller = CarouselController();
  final Map<String, ImageProvider> _imageCache = {};
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImages();
  }

  Future<void> _precacheImages() async {
    if (!mounted) return;

    for (var item in items) {
      final String imagePath = 'assets${item['image']}';
      if (!_imageCache.containsKey(imagePath)) {
        final provider = AssetImage(imagePath);
        _imageCache[imagePath] = provider;
        await precacheImage(provider, context);
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildCarouselImage(String imagePath, BoxConstraints constraints) {
    return Image.asset(
      'assets$imagePath',
      fit: BoxFit.contain,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            width: constraints.maxWidth,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      cacheWidth: (MediaQuery.of(context).size.width * 0.8).round(),
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: constraints.maxWidth,
          height: 200,
          child: const Center(
            child: Icon(Icons.error_outline, size: 40),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Text(
                  'Deneme Takip',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Yeni Nesil YKS Takip Uygulaması',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 16),
                PrimaryButton(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Hemen Katıl', style: TextStyle(fontSize: 14),
                  ) ),
                  onPressed: () => context.go("/kayit-ol"),
                )
              ],
            ),
          ),
          _isLoading?Container(
            margin: EdgeInsets.only(top: 24),
            child: Center(
                      child: CircularProgressIndicator(
                  size: 48,
                ))) :
          SizedBox(
            height: 500,
            child: Carousel(
                transition: CarouselTransition.sliding(),
                controller: controller,
                draggable: true,
                autoplayReverse: false,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Container(
                      
                      margin: EdgeInsets.only(top: 24),
                      width: double.infinity,
                      child: Card(
                          fillColor: index/2 == 0 ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.foreground,
                          filled: true,
                          borderColor: Theme.of(context).colorScheme.border,
                          borderWidth: 1,
                          child: Column(
                            children: [
                              LayoutBuilder(
                                builder: (context, constraints) =>
                                    _buildCarouselImage(
                                        items[index]['image'], constraints),
                              ),
                              SizedBox(height: 16),
                              Text(items[index]['title'],
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: index/2 == 0 ? Theme.of(context).colorScheme.foreground : Theme.of(context).colorScheme.background
                                  )),
                              SizedBox(height: 12),
                              Text(items[index]['description'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: index/2 == 0 ? Theme.of(context).colorScheme.foreground : Theme.of(context).colorScheme.background
   )),
                            ],
                          )));
                }),
          ),
        ],
      ),
    );
  }
}
