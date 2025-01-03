import 'dart:async';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/hubUrls.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/receiveFunctions.dart';
import 'package:mobil_denemetakip/constants/spinner.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/auth-service.dart';
import 'package:mobil_denemetakip/services/deneme-service.dart';
import 'package:mobil_denemetakip/services/dersler-service.dart';
import 'package:mobil_denemetakip/services/konular-service.dart';
import 'package:mobil_denemetakip/services/signalr-service.dart';
import 'package:mobil_denemetakip/services/use-signalr.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TytCreate extends StatefulWidget {
  final bool isAyt;

  const TytCreate({
    super.key,
    required this.isAyt,
  });
  @override
  State<TytCreate> createState() => _TytCreateState();
}

class _TytCreateState extends State<TytCreate> {
  var derslerService = DerslerService();
  var konularService = KonularService();
  var denemeService = DenemeService();
  SignalRService? signalRService;
  final authService = AuthService();

  CheckboxState _state = CheckboxState.unchecked;
  int totalCountOfKonular = 0;
  String selectedDersId = "";
  int page = 1;
  int pageSize = 10;
  List<String> bosKonularId = [];
  List<String> yanlisKonularId = [];
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

  @override
  void initState() {
    super.initState();
    _fetchDersler();
    _scrollController.addListener(_onScroll);

    signalRService = UseSignalR.of(context);
    final userId = authService.userId;
    signalRService!.on(HubUrls.TytHub.url, ReceiveFunctions.TytAddedMessage,
        (message) {
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
    final userId = authService.userId;
    if (signalRService != null && userId != null) {
      signalRService!.off(HubUrls.TytHub.url, ReceiveFunctions.TytAddedMessage,
          userId: userId);
    }
    super.dispose();
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

  Future<void> _fetchDersler() async {
    isLoading.value = true;
    try {
      final data = await derslerService.getAllDers(isTyt: !widget.isAyt);
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

  Future<void> createTyt() async {
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
    final tytDeneme = CreateTyt(
      matematikDogru: int.parse(dogruControllers["Matematik"]?.text ?? '0'),
      matematikYanlis: int.parse(yanlisControllers["Matematik"]?.text ?? '0'),
      turkceDogru: int.parse(dogruControllers["Türkçe"]?.text ?? '0'),
      turkceYanlis: int.parse(yanlisControllers["Türkçe"]?.text ?? '0'),
      fenDogru: int.parse(dogruControllers["Fen"]?.text ?? '0'),
      fenYanlis: int.parse(yanlisControllers["Fen"]?.text ?? '0'),
      sosyalDogru: int.parse(dogruControllers["Sosyal"]?.text ?? '0'),
      sosyalYanlis: int.parse(yanlisControllers["Sosyal"]?.text ?? '0'),
      yanlisKonularId: yanlisKonularId,
      bosKonularId: bosKonularId,
      denemeDate: denemeDate,
    );
    isLoading.value = true;
    try {
      await denemeService.createTyt(tytDeneme);
      setState(() {
        yanlisKonularId.clear();
        bosKonularId.clear();

        dogruControllers.forEach((key, controller) {
          controller.text = '0';
        });
        yanlisControllers.forEach((key, controller) {
          controller.text = '0';
        });
      });
    } catch (error) {
      errorToast("Hata", "$error", Navigator.of(context).context);
    }
    isLoading.value = false;
  }

  Future<void> _fetchKonular(String dersId, String? konuAdi) async {
    page = 1;
    try {
      final data = await konularService.getAllKonular(
          isTyt: !widget.isAyt,
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
        isTyt: !widget.isAyt,
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
          isTyt: !widget.isAyt,
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (BuildContext context, isLoadingInside, _) {
        if (isLoadingInside) {
          return SpinnerWidget();
        } else {
          return SingleChildScrollView(
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
                                      child: NumberInput(
                                        controller:
                                            dogruControllers[item.dersAdi],
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
                                        controller:
                                            yanlisControllers[item.dersAdi],
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
                                        Text('Yanlış veya Boş Konu Seç',
                                            style: TextStyle(fontSize: 14)),
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
                  child: Text("Deneme Ekle", style: TextStyle(fontSize: 14)),
                  onPressed: () {
                    createTyt();
                  },
                ),
              ),
            ],
          ));
        }
      },
    );
  }
}
