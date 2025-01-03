import 'dart:async';

import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/hubUrls.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/receiveFunctions.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/auth-service.dart';
import 'package:mobil_denemetakip/services/deneme-service.dart';
import 'package:mobil_denemetakip/services/dersler-service.dart';
import 'package:mobil_denemetakip/services/konular-service.dart';
import 'package:mobil_denemetakip/services/signalr-service.dart';
import 'package:mobil_denemetakip/services/use-signalr.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SingleAytContent extends StatefulWidget {
  final String aytId;
  const SingleAytContent({Key? key, required this.aytId}) : super(key: key);

  @override
  State<SingleAytContent> createState() => _SingleAytContentState();
}


class _SingleAytContentState extends State<SingleAytContent> {
  late String aytId;
  String selectedDersId = "";
  int page = 1;
  int pageSize = 10;
  List<String> bosKonularId = [];
  List<String> yanlisKonularId = [];

  ValueChangeNotifier<AytSingleList?> aytSingleList = ValueChangeNotifier(null);
  DateTime? _denemeDate;
  ValueNotifier<List<ListKonu>> konularNotifier = ValueNotifier([]);
  ValueNotifier<int> totalPage = ValueNotifier(0);
  ValueNotifier<bool> isLoadingKonu = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<List<String>> yanlisKonularNotifier = ValueNotifier([]);
  ValueNotifier<List<String>> bosKonularNotifier = ValueNotifier([]);
  List<Ders> dersler = [];
  Timer? _debounce;
  ScrollController _scrollController = ScrollController();
  Map<String, TextEditingController> dogruControllers = {};
  Map<String, TextEditingController> yanlisControllers = {};

  final denemeService = DenemeService();
  final derslerService = DerslerService();
  final konularService = KonularService();
  SignalRService? signalRService;
  final authService = AuthService();

  final Map<String, int> maxLimits = {
    "Matematik": 40,
    "Fizik": 14,
    "Kimya": 13,
    "Biyoloji": 13,
    "Edebiyat": 24,
    "Tarih1": 10,
    "Coğrafya1": 6,
    "Tarih2": 11,
    "Coğrafya2": 11,
    "Felsefe": 12,
    "Din": 6,
    "Dil": 80,
  };

  Future<void> _fetchAyt() async {
    var response = await denemeService.getAytById(aytId);
    setState(() {
      aytSingleList.value = response;
      bosKonularId = aytSingleList.value!.bosKonularAdDers
          .map((bosKonularAd) => bosKonularAd.konuId)
          .toList();
      yanlisKonularId = aytSingleList.value!.yanlisKonularAdDers
          .map((yanlisKonularAd) => yanlisKonularAd.konuId)
          .toList();
      _denemeDate = aytSingleList.value!.denemeDate;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      var nextPage = ++page;
      if (nextPage > totalPage.value) {
        return;
      }
      loadMoreKonu(nextPage);
    }
  }

  int getDogruValue(String dersAdi) {
    final data = aytSingleList.value;
    if (data == null) return 0;

    switch (dersAdi) {
      case "Matematik":
        return data.matematikDogru;
      case "Fizik":
        return data.fizikDogru;
      case "Biyoloji":
        return data.biyolojiDogru;
      case "Kimya":
        return data.kimyaDogru;

      case "Edebiyat":
      return data.edebiyatDogru;
      case "Tarih1":
        return data.tarih1Dogru;
      case "Coğrafya1":
        return data.cografya1Dogru;

      case "Tarih2":
        return data.tarih2Dogru;
      case "Coğrafya2":
        return data.cografya2Dogru;
      case "Felsefe":
        return data.felsefeDogru;  
      case "Din":
        return data.dinDogru;
        
      case "Dil":
        return data.dilDogru;
      default:
        return 0;
    }
  }

  int getYanlisValue(String dersAdi) {
    final data = aytSingleList.value;
    if (data == null) return 0;

    switch (dersAdi) {
      case "Matematik":
        return data.matematikYanlis;
      case "Fizik":
        return data.fizikYanlis;
      case "Biyoloji":
        return data.biyolojiYanlis;
      case "Kimya":
        return data.kimyaYanlis;

      case "Edebiyat":
      return data.edebiyatYanlis;
      case "Tarih1":
        return data.tarih1Yanlis;
      case "Coğrafya1":
        return data.cografya1Yanlis;

      case "Tarih2":
        return data.tarih2Yanlis;
      case "Coğrafya2":
        return data.cografya2Yanlis;
      case "Felsefe":
        return data.felsefeYanlis;  
      case "Din":
        return data.dinYanlis;

      case "Dil":
        return data.dilYanlis;
      default:
        return 0;
    }
  }

  Future<void> _fetchDersler() async {
    isLoading.value = true;
    try {
      final data = await derslerService.getAllDers(isTyt: false);
      setState(() {
        dersler = data['dersler'];
        for (var ders in dersler) {
          dogruControllers[ders.dersAdi] = TextEditingController();
          yanlisControllers[ders.dersAdi] = TextEditingController();
        }
      });
    } catch (error) {
      if (mounted) {
        errorToast("Hata", "$error", Navigator.of(context).context);
      }
    }
    isLoading.value = false;
  }

  Future<void> _fetchKonular(String dersId, String? konuAdi) async {
    page = 1;
    try {
      final data = await konularService.getAllKonular(
          isTyt: false,
          konuOrDersAdi: konuAdi,
          dersIds: [dersId],
          page: page,
          size: pageSize);
      konularNotifier.value = data['konular'];
      totalPage.value = (data['totalCount'] / pageSize).ceil();
    } catch (error) {
      errorToast("Hata", "$error", Navigator.of(context).context);
    }
  }

  Future<void> loadMoreKonu(int currentPage) async {
    isLoadingKonu.value = true;
    double currentScrollPosition = _scrollController.position.pixels;
    try {
      final data = await konularService.getAllKonular(
        isTyt: false,
        page: currentPage,
        size: pageSize,
        dersIds: [selectedDersId!],
      );
      konularNotifier.value = [...konularNotifier.value, ...data['konular']];
    } catch (error) {
      errorToast("Hata", "$error", Navigator.of(context).context);
    } finally {
      isLoadingKonu.value = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(currentScrollPosition);
      });
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      page = 1;
      isLoadingKonu.value = true;
      try {
        final response = await konularService.getAllKonular(
          isTyt: false,
          konuOrDersAdi: value,
          dersIds: [selectedDersId!],
          page: 1,
          size: pageSize,
        );
        konularNotifier.value = response['konular'];
      } catch (error) {
        errorToast("Hata", 'Konular alınırken bir hata oluştu.',
            Navigator.of(context).context);
      }
      isLoadingKonu.value = false;
    });
  }
  Future<void> updateAyt() async {
    final now = DateTime.now().toUtc();
    final denemeDate = _denemeDate != null
        ? DateTime(
            _denemeDate!.year,
            _denemeDate!.month,
            _denemeDate!.day,
            now.hour + 3,
            now.minute,
            now.second,
          )
        : DateTime(
            now.year,
            now.month,
            now.day,
            now.hour + 3,
            now.minute,
            now.second,
          );
    final aytUpdate = UpdateAyt(
      aytId: aytSingleList.value!.id,

      matematikDogru: int.parse(dogruControllers["Matematik"]?.text ?? '0'),
      matematikYanlis: int.parse(yanlisControllers["Matematik"]?.text ?? '0'),
      fizikDogru: int.parse(dogruControllers["Fizik"]?.text ?? '0'),
      fizikYanlis: int.parse(yanlisControllers["Fizik"]?.text ?? '0'),
      kimyaDogru: int.parse(dogruControllers["Kimya"]?.text ?? '0'),
      kimyaYanlis: int.parse(yanlisControllers["Kimya"]?.text ?? '0'),
      biyolojiDogru: int.parse(dogruControllers["Biyoloji"]?.text ?? '0'),
      biyolojiYanlis: int.parse(yanlisControllers["Biyoloji"]?.text ?? '0'),

      edebiyatDogru: int.parse(dogruControllers["Edebiyat"]?.text ?? '0'),
      edebiyatYanlis: int.parse(yanlisControllers["Edebiyat"]?.text ?? '0'),
      tarih1Dogru: int.parse(dogruControllers["Tarih1"]?.text ?? '0'),
      tarih1Yanlis: int.parse(yanlisControllers["Tarih1"]?.text ?? '0'),
      cografya1Dogru: int.parse(dogruControllers["Coğrafya1"]?.text ?? '0'),
      cografya1Yanlis: int.parse(yanlisControllers["Coğrafya1"]?.text ?? '0'),

      tarih2Dogru: int.parse(dogruControllers["Tarih2"]?.text ?? '0'),
      tarih2Yanlis: int.parse(yanlisControllers["Tarih2"]?.text ?? '0'),
      cografya2Dogru: int.parse(dogruControllers["Coğrafya2"]?.text ?? '0'),
      cografya2Yanlis: int.parse(yanlisControllers["Coğrafya2"]?.text ?? '0'),
      felsefeDogru: int.parse(dogruControllers["Felsefe"]?.text ?? '0'),
      felsefeYanlis: int.parse(yanlisControllers["Felsefe"]?.text ?? '0'),
      dinDogru: int.parse(dogruControllers["Din"]?.text ?? '0'),
      dinYanlis: int.parse(yanlisControllers["Din"]?.text ?? '0'),

      dilDogru: int.parse(dogruControllers["Dil"]?.text ?? '0'),
      dilYanlis: int.parse(yanlisControllers["Dil"]?.text ?? '0'),

      yanlisKonular: yanlisKonularId,
      bosKonular: bosKonularId,
      denemeDate: denemeDate,
    );
    isLoading.value = true;
    await denemeService.updateAyt(aytUpdate, successCallback: () {
      successToast("Başarılı", "AYT denemesi başarıyla güncellendi.",
          Navigator.of(context).context);
    }, errorCallback: (error) {
      errorToast("Hata", "$error", Navigator.of(context).context);
    });
    isLoading.value = false;
  }
  
  @override
  void initState() {
    super.initState();
    aytId = widget.aytId;
    _fetchAyt();
    _fetchDersler();
    _scrollController.addListener(_onScroll);

    signalRService = UseSignalR.of(context);
    final userId = authService.userId;
    signalRService!.on(HubUrls.AytHub.url, ReceiveFunctions.AytUpdatedMessage,
        (message) {
      _fetchAyt();
      final parsedMessage =
          message is List && message.isNotEmpty ? message[0] : message;
      successToast("Başarılı", "$parsedMessage", Navigator.of(context).context);
    }, userId: userId);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    dogruControllers.forEach((key, controller) => controller.dispose());
    yanlisControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (BuildContext context, isLoadingInside, _) {
        if (isLoadingInside) {
          return Center(
            child: const CircularProgressIndicator(
              size: 48,
            ),
          );
        } return SingleChildScrollView(
              child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    DatePicker(
                      value: _denemeDate,
                      mode: PromptMode.dialog,
                      dialogTitle: const Text('Tarih Seç'),
                      stateBuilder: (date) {
                        return DateState.enabled;
                      },
                      onChanged: (value) {
                        setState(() {
                          _denemeDate = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: dersler.map((item) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.dersAdi,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
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
                                      child: ValueListenableBuilder<
                                          AytSingleList?>(
                                        valueListenable: aytSingleList,
                                        builder: (context, value, child) {
                                          if (value == null) {
                                            return Center(child:CircularProgressIndicator(size: 48,)); 
                                          }
                                          return NumberInput(
                                              initialValue: getDogruValue(item.dersAdi).toDouble(),
                                              min: 0,
                                              max: (maxLimits[item.dersAdi] ??
                                                      0)
                                                  .toDouble(),
                                              allowDecimals: false,
                                              controller: dogruControllers[
                                                  item.dersAdi]);
                                        },
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
                                      child: ValueListenableBuilder<
                                          AytSingleList?>(
                                        valueListenable: aytSingleList,
                                        builder: (context, value, child) {
                                          return NumberInput(
                                              initialValue:getYanlisValue(item.dersAdi).toDouble(),
                                              min: 0,
                                              max:
                                                  (maxLimits[item.dersAdi] ?? 0)
                                                      .toDouble(),
                                              allowDecimals: false,
                                              controller: yanlisControllers[
                                                  item.dersAdi]);
                                        },
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
                                          height: 400,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextField(
                                                  placeholder:
                                                      Text('Konu arayın...'),
                                                  trailing:
                                                      StatedWidget.builder(
                                                    builder: (context, states) {
                                                      if (states.focused) {
                                                        return Icon(
                                                            Icons.search);
                                                      } else {
                                                        return Icon(
                                                                Icons.search)
                                                            .iconMutedForeground();
                                                      }
                                                    },
                                                  ),
                                                  onChanged: _onSearchChanged,
                                                ),
                                              ),
                                              Expanded(
                                                  child: ValueListenableBuilder<
                                                          bool>(
                                                      valueListenable:
                                                          isLoadingKonu,
                                                      builder: (context,
                                                          isLoadingKonuInside,
                                                          _) {
                                                        if (isLoadingKonuInside) {
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              size: 36,
                                                            ),
                                                          );
                                                        } else {
                                                          return ValueListenableBuilder<
                                                              List<ListKonu>>(
                                                            valueListenable:
                                                                konularNotifier,
                                                            builder: (context,
                                                                konular, _) {
                                                              if (isLoadingKonu
                                                                  .value) {
                                                                return Center(
                                                                  child:
                                                                      const CircularProgressIndicator(
                                                                    size: 36,
                                                                  ),
                                                                );
                                                              }
                                                              if (konular
                                                                  .isEmpty) {
                                                                return Center(
                                                                  child: Text(
                                                                    'Konu bulunamadı.',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .foreground),
                                                                  ),
                                                                );
                                                              } else {
                                                                return SingleChildScrollView(
                                                                  controller:
                                                                      _scrollController,
                                                                  child: Column(
                                                                    children:
                                                                        konular.map(
                                                                            (konu) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                16.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                konu.konuAdi,
                                                                                style: TextStyle(fontSize: 16),
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      final newState = yanlisKonularId.contains(konu.id) ? CheckboxState.unchecked : CheckboxState.checked;

                                                                                      if (newState == CheckboxState.checked) {
                                                                                        yanlisKonularId.add(konu.id);
                                                                                      } else {
                                                                                        yanlisKonularId.remove(konu.id);
                                                                                      }
                                                                                      yanlisKonularNotifier.value = List.from(yanlisKonularId);
                                                                                    });
                                                                                  },
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text("Yanlış"),
                                                                                      ValueListenableBuilder<List<String>>(
                                                                                        valueListenable: yanlisKonularNotifier,
                                                                                        builder: (context, yanlisKonular, _) {
                                                                                          return Checkbox(
                                                                                            state: yanlisKonularId.contains(konu.id) ? CheckboxState.checked : CheckboxState.unchecked,
                                                                                            onChanged: (CheckboxState? newState) {
                                                                                              setState(() {
                                                                                                if (newState == CheckboxState.checked) {
                                                                                                  yanlisKonularId.add(konu.id);
                                                                                                } else {
                                                                                                  yanlisKonularId.remove(konu.id);
                                                                                                }
                                                                                                yanlisKonularNotifier.value = List.from(yanlisKonularId);
                                                                                              });
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            // Boş Checkbox
                                                                            Row(
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      final newState = bosKonularId.contains(konu.id) ? CheckboxState.unchecked : CheckboxState.checked;

                                                                                      if (newState == CheckboxState.checked) {
                                                                                        bosKonularId.add(konu.id);
                                                                                      } else {
                                                                                        bosKonularId.remove(konu.id);
                                                                                      }
                                                                                      bosKonularNotifier.value = List.from(bosKonularId);
                                                                                    });
                                                                                  },
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Text("Boş"),
                                                                                      ValueListenableBuilder<List<String>>(
                                                                                        valueListenable: bosKonularNotifier,
                                                                                        builder: (context, bosKonular, _) {
                                                                                          return Checkbox(
                                                                                            state: bosKonularId.contains(konu.id) ? CheckboxState.checked : CheckboxState.unchecked,
                                                                                            onChanged: (CheckboxState? newState) {
                                                                                              setState(() {
                                                                                                if (newState == CheckboxState.checked) {
                                                                                                  bosKonularId.add(konu.id);
                                                                                                } else {
                                                                                                  bosKonularId.remove(konu.id);
                                                                                                }
                                                                                                bosKonularNotifier.value = List.from(bosKonularId);
                                                                                              });
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          );
                                                        }
                                                      }))
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ).future.then((_) {});
                                },
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Yanlış veya Boş Konu Seç',style: TextStyle(fontSize: 14)
                                        ),
                                        Icon(LucideIcons.chevronsUpDown),
                                      ],
                                    ))),
                          )
                        ],
                      ));
                }).toList(),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: PrimaryButton(
                  child: Text("Güncelle", style: TextStyle(fontSize: 14)),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Güncelleme Onayı"),
                            content: Text(
                                "AYT denemesini güncellemek istediğinize emin misiniz?"),
                            actions: [
                              OutlineButton(
                                child: const Text('İptal'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              PrimaryButton(
                                child: const Text('Güncelle'),
                                onPressed: () {
                                  updateAyt();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
              )
            ],
          ));
  });
  }
}