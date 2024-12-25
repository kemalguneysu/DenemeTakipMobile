import 'dart:ffi';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/deneme-service.dart';
import 'package:mobil_denemetakip/services/dersler-service.dart';
import 'package:mobil_denemetakip/services/konular-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TytCreate extends StatefulWidget {
  final bool isAyt;
  
  const TytCreate({super.key, required this.isAyt});
  @override
  State<TytCreate> createState() => _TytCreateState();
}

class _TytCreateState extends State<TytCreate> {
  var derslerService = DerslerService();
  var konularService = KonularService();
  var denemeService = DenemeService();


  CheckboxState _state = CheckboxState.unchecked;
  List<Ders> dersler = [];
  List<ListKonu> konular = [];
  int totalCountOfKonular=0;
  String selectedDersId="";
  int page=1;
  int pageSize=5;

  List<String> bosKonularId = [];
  List<String> yanlisKonularId = [];
  ValueNotifier<List<String>> yanlisKonularNotifier = ValueNotifier([]);
  ValueNotifier<List<String>> bosKonularNotifier = ValueNotifier([]);

   @override
  void initState() {
    super.initState();
    _fetchDersler();
  }
  Future<void> createTyt()async{
  }
  Future<void> _fetchDersler() async {
    try {
      final data = await derslerService.getAllDers(isTyt: !widget.isAyt);
      setState(() {
        dersler = data['dersler'];
      });
    } catch (error) {
      errorToast("Hata", "$error", Navigator.of(context).context);
    }
  }
  Future<void> _fetchKonular(String dersId,String? konuAdi) async{
    page=1;
    try {
      final data = await konularService.getAllKonular(isTyt: !widget.isAyt, konuOrDersAdi: konuAdi ,dersIds: [dersId], page: page, size: pageSize);
      setState(() {
        konular = data['konular'];
        totalCountOfKonular = data['totalCount'];
      });
    } catch (error) {
      errorToast("Hata", "$error", Navigator.of(context).context);
    }
  }
  Future<void> loadMoreKonu(int currentPage) async {
    try {
      final data = await konularService.getAllKonular(
        isTyt: !widget.isAyt,
        page: currentPage,
        size: pageSize,
        dersIds: [selectedDersId!],
      );
      setState(() {
        konular.addAll(data['konular']);
      });
    } catch (error) {
      errorToast("Hata", "$error", Navigator.of(context).context);
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
        Column(
          children: dersler.map((item) {
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.dersAdi,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text("Doğru: "),
                              SizedBox(width: 8),
                              Expanded(
                                child: NumberInput(
                                  min: 0,
                                  max: item.dersAdi == "Türkçe" ||
                                          item.dersAdi == "Matematik"
                                      ? 40
                                      : 20,
                                  allowDecimals: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            children: [
                              Text("Yanlış: "),
                              SizedBox(width: 8),
                              Expanded(
                                child: NumberInput(
                                  min: 0,
                                  max: item.dersAdi == "Türkçe" ||
                                          item.dersAdi == "Matematik"
                                      ? 40
                                      : 20,
                                  allowDecimals: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      child: PrimaryButton(
                        onPressed: () async {
                          selectedDersId = item.id;
                          await _fetchKonular(item.id, null);
                          showPopover(
                            context: context,
                            alignment: Alignment.topCenter,
                            offset: const Offset(0, 8),
                            overlayBarrier: OverlayBarrier(),
                            builder: (context) {
                              return SurfaceCard(
                                child: SizedBox(
                                  width: 300,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SingleChildScrollView(
                                        child: Column(
                                          children: konular.map((konu) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 16.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      konu.konuAdi,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Yanlış"),
                                                      ValueListenableBuilder<
                                                          List<String>>(
                                                        valueListenable:
                                                            yanlisKonularNotifier,
                                                        builder: (context,
                                                            yanlisKonular, _) {
                                                          return Checkbox(
                                                            state: yanlisKonularId
                                                                    .contains(
                                                                        konu.id)
                                                                ? CheckboxState
                                                                    .checked
                                                                : CheckboxState
                                                                    .unchecked,
                                                            onChanged:
                                                                (CheckboxState
                                                                    newState) {
                                                              setState(() {
                                                                if (newState ==
                                                                    CheckboxState
                                                                        .checked) {
                                                                  yanlisKonularId
                                                                      .add(konu
                                                                          .id);
                                                                } else {
                                                                  yanlisKonularId
                                                                      .remove(konu
                                                                          .id);
                                                                }
                                                                yanlisKonularNotifier
                                                                        .value =
                                                                    List.from(
                                                                        yanlisKonularId);
                                                              });
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  // Boş Checkbox
                                                  Row(
                                                    children: [
                                                      Text("Boş"),
                                                      ValueListenableBuilder<
                                                          List<String>>(
                                                        valueListenable:
                                                            bosKonularNotifier,
                                                        builder: (context,
                                                            bosKonular, _) {
                                                          return Checkbox(
                                                            state: bosKonularId
                                                                    .contains(
                                                                        konu.id)
                                                                ? CheckboxState
                                                                    .checked
                                                                : CheckboxState
                                                                    .unchecked,
                                                            onChanged:
                                                                (CheckboxState
                                                                    newState) {
                                                              setState(() {
                                                                if (newState ==
                                                                    CheckboxState
                                                                        .checked) {
                                                                  bosKonularId
                                                                      .add(konu
                                                                          .id);
                                                                } else {
                                                                  bosKonularId
                                                                      .remove(konu
                                                                          .id);
                                                                }
                                                                bosKonularNotifier
                                                                        .value =
                                                                    List.from(
                                                                        bosKonularId);
                                                              });
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).future.then((_) {});
                        },
                        child:Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Yanlış veya Boş Konu Seç',),
                              Icon(LucideIcons.chevronsUpDown),
                            ],
                          )
                        ) 
                      ),
                    )
                  ],
                ));
          }).toList(),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: PrimaryButton(
            child: Text("Deneme Ekle"),
            onPressed: () {
              createTyt();
            },
          ),
        )
       
        
      ],
      )
      
    );
  }
}