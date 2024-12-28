import 'dart:math';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/spinner.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/deneme-service.dart';
import 'package:mobil_denemetakip/services/dersler-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TytCarousel extends StatefulWidget {
  const TytCarousel({super.key});

  @override
  State<TytCarousel> createState() => _TytCarouselState();
}

class _TytCarouselState extends State<TytCarousel> {
  List<Ders> dersler = [];
  ValueNotifier<List<DenemeAnaliz>> konular = ValueNotifier([]);

  var derslerService = DerslerService();
  var denemeService = DenemeService();
  final CarouselController controller = CarouselController();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  int selectedIndex = 0;
  Future<void> _fetchDersler() async {
    isLoading.value = true;
    try {
      final data = await derslerService.getAllDers(isTyt: true);
      setState(() {
        dersler = data['dersler'];
      });
      await _fetchKonular(dersler[0].id);
    } catch (error) {}
    isLoading.value = false;
  }

  Future<void> _fetchKonular(String dersId) async {
    isLoading.value = true;
    try {
      final result = await denemeService.getTytAnaliz(
        denemeSayisi: 5,
        konuSayisi: 3,
        dersId: dersId,
        type: "yanlis",
      );
      if (result != null) {
        setState(() {
          konular.value = result;
        });
      }
    } catch (error) {
      if (mounted) {
        errorToast("Hata", "$error", Navigator.of(context).context);
      }
    }
    isLoading.value = false;
  }

  @override
  void initState() {
    super.initState();
    _fetchDersler();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isLoading,
        builder: (BuildContext context, isLoadingInside, _) {
          return SizedBox(
            height: 800,
            child: Column(
              children: [
                SizedBox(
                  height: konular.value.length == 0 ? 180 : min(150+konular.value.length*30,220),
                  child: Carousel(
                    onIndexChanged: (value) => {
                      if (value == dersler.length)
                        {_fetchKonular(dersler[0].id)}
                      else
                        _fetchKonular(dersler[value].id)
                    },
                    transition: CarouselTransition.sliding(),
                    controller: controller,
                    draggable: true,
                    autoplayReverse: false,
                    itemCount: dersler.length,
                    itemBuilder: (context, index) {
                      if (isLoadingInside) {
                        return SpinnerWidget();
                      } else {
                        return Container(
                            margin: EdgeInsets.only(top: 24),
                            width: double.infinity,
                            child: Card(
                                borderColor:
                                    Theme.of(context).colorScheme.border,
                                borderWidth: 1,
                                child: Container(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Container(
                                        child: Text(
                                            "Son 5 TYT denemesi ${dersler[index].dersAdi} dersi için",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w300)),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 16),
                                        alignment: Alignment.center,
                                        child: Text(
                                            "En Fazla Yanlış Yapılan Konular",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      SizedBox(height: 10,),
                                      Container(
                                        child: Column(
                                          children: konular.value.isEmpty? [
                                            Container(
                                              margin: EdgeInsets.only(top: 8),
                                              alignment: Alignment.center,
                                              child: Text("${dersler[index].dersAdi} dersinde yanlış yaptığınız konu bulunmamaktadır.",
                                              textAlign: TextAlign.center,style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w300
                                              ),)
                                              )
                                            ,
                                            ]: konular.value.map((konu) {
                                               return Container(
                                                    padding: const EdgeInsets.symmetric( vertical: 4.0),
                                                    child: Row(
                                                      children: [
                                                        Text('• ',
                                                            style: TextStyle(
                                                                fontSize: 18,fontWeight: FontWeight.bold)),
                                                        Expanded(
                                                          child: Text(
                                                            '${konu.konuAdi} - ${konu.sayi} adet',
                                                            style: TextStyle(
                                                                fontSize: 18,fontWeight: FontWeight.w300),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                              }).toList(),
                                        ),
                                      )
                                    ]))));
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlineButton(
                      shape: ButtonShape.circle,
                      onPressed: () {
                        controller
                            .animatePrevious(const Duration(milliseconds: 500));
                      },
                      child: Icon(LucideIcons.arrowLeft),
                    ),
                    OutlineButton(
                      shape: ButtonShape.circle,
                      onPressed: () {
                        controller
                            .animateNext(const Duration(milliseconds: 500));
                      },
                      child: Icon(LucideIcons.arrowRight),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
