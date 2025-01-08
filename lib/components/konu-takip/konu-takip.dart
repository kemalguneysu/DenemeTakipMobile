import 'dart:async';

import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/spinner.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/dersler-service.dart';
import 'package:mobil_denemetakip/services/konular-service.dart';
import 'package:mobil_denemetakip/services/userKonular-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class KonuTakip extends StatefulWidget {
  const KonuTakip({super.key});

  @override
  State<KonuTakip> createState() => _KonuTakipState();
}

class _KonuTakipState extends State<KonuTakip> {
  bool isAyt = false;
  String selectedDersId = "";
  int page = 1;
  int pageSize = 10;
  ValueNotifier<int> userKonularCount = ValueNotifier(0);
  ValueNotifier<int> realTotalCount = ValueNotifier(0);
  var derslerService = DerslerService();
  var konularService = KonularService();
  var userKonular = UserKonularService();

  List<Ders> dersler = [];
  ValueNotifier<List<ListKonu>> konularNotifier = ValueNotifier([]);

  ValueNotifier<int> totalPage = ValueNotifier(0);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isLoadingKonu = ValueNotifier(false);
  ValueNotifier<List<ListUserKonular>> userKonularNotifier = ValueNotifier([]);

  Timer? _debounce;
  ScrollController _scrollController = ScrollController();

  Future<void> _fetchDersler() async {
    isLoading.value = true;
    try {
      final data = await derslerService.getAllDers(isTyt: !isAyt);
      setState(() {
        dersler = data['dersler'];
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
          isTyt: !isAyt,
          konuOrDersAdi: konuAdi,
          dersIds: [dersId],
          page: page,
          size: pageSize);
      konularNotifier.value = data['konular'];
      totalPage.value = (data['totalCount'] / pageSize).ceil();
      _fetchRealTotalCount(dersId);
    } catch (error) {
      errorToast("Hata", "$error", Navigator.of(context).context);
    }
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

  Future<void> loadMoreKonu(int currentPage) async {
    isLoadingKonu.value = true;
    double currentScrollPosition = _scrollController.position.pixels;
    try {
      final data = await konularService.getAllKonular(
        isTyt: !isAyt,
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
          isTyt: !isAyt,
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

  Future<void> _fetchUserKonular() async {
    isLoading.value = true;
    try {
      final data = await userKonular.getUserKonular(dersId: selectedDersId);
      List<ListUserKonular> konularList = (data['userKonular'] as List<dynamic>)
          .map((item) => ListUserKonular.fromJson(item as Map<String, dynamic>))
          .toList();
      setState(() {
        userKonularNotifier.value = konularList;
        userKonularCount.value = data['totalCount'];
      });
    } catch (error) {
      if (mounted) {
        errorToast("Hata", "$error", Navigator.of(context).context);
      }
    }
    isLoading.value = false;
  }

  Future<void> _fetchRealTotalCount(String dersId) async {
    isLoading.value = true;
    try {
      final data =
          await konularService.getAllKonular(isTyt: !isAyt, dersIds: [dersId]);
      setState(() {
        realTotalCount.value = data['totalCount'];
      });
    } catch (error) {
      if (mounted) {
        errorToast("Hata", "$error", Navigator.of(context).context);
      }
    }
    isLoading.value = false;
  }

  Future<void> _updateUserKonu(String konuId) async {
    isLoading.value = true;
    try {
      final data = await userKonular
          .createUserKonu(CreateUserKonu(konuIds: [konuId]), () {
        _fetchUserKonular();
      });
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
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
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
                child: Column(children: [
              Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.topLeft,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          leading: const Text(
                            "TYT",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          value: isAyt,
                          onChanged: (value) {
                            setState(() {
                              this.isAyt = value;
                            });
                            _fetchDersler();
                          },
                          trailing: const Text(
                            "AYT",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: dersler.map((item) {
                        return Container(
                            margin: EdgeInsets.only(top: 16),
                            width: double.infinity,
                            child: GestureDetector(
                                onTap: () async {
                                  selectedDersId = item.id;
                                  await _fetchKonular(item.id, null);
                                  await _fetchUserKonular();
                                  showPopover(
                                      context: context,
                                      alignment: Alignment.topCenter,
                                      builder: (context) {
                                        return SurfaceCard(
                                          child: SizedBox(
                                            width: 300,
                                            height: 450,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 8),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        item.dersAdi,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      ValueListenableBuilder(
                                                          valueListenable:
                                                              userKonularCount,
                                                          builder: (context,
                                                              userCount, _) {
                                                            return ValueListenableBuilder(
                                                                valueListenable:
                                                                    realTotalCount,
                                                                builder: (context,
                                                                    totalCount,
                                                                    _) {
                                                                  return Text(
                                                                    "${totalCount} konudan ${userCount} tanesi tamamlandı. "
                                                                    "${konularNotifier.value.isNotEmpty ? ((userCount / totalCount) * 100).toStringAsFixed(2) : 0}%",
                                                                  );
                                                                });
                                                          })
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    placeholder:
                                                        Text('Konu arayın...'),
                                                    trailing:
                                                        StatedWidget.builder(
                                                      builder:
                                                          (context, states) {
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
                                                                    child:
                                                                        Column(
                                                                      children:
                                                                          konular
                                                                              .map((konu) {
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 8.0,
                                                                              horizontal: 16.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    setState(() {
                                                                                      _updateUserKonu(konu.id);
                                                                                    });
                                                                                  },
                                                                                  child: Text(
                                                                                    konu.konuAdi,
                                                                                    style: TextStyle(fontSize: 16),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Row(
                                                                                      children: [
                                                                                        ValueListenableBuilder<List<ListUserKonular>>(
                                                                                          valueListenable: userKonularNotifier,
                                                                                          builder: (context, userKonular, _) {
                                                                                            final isChecked = userKonular.any((userKonu) => userKonu.konuId == konu.id);
                                                                                            return Checkbox(
                                                                                              state: userKonular.any((userKonu) => userKonu.konuId == konu.id) ? CheckboxState.checked : CheckboxState.unchecked,
                                                                                              onChanged: (CheckboxState? newState) {
                                                                                                setState(() {
                                                                                                  _updateUserKonu(konu.id);
                                                                                                });
                                                                                              },
                                                                                            );
                                                                                          },
                                                                                        ),
                                                                                      ],
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
                                      }).future.then((_) {});
                                },
                                child: Card(
                                  borderColor:
                                      Theme.of(context).colorScheme.border,
                                  borderWidth: 1,
                                  child: Text(
                                    item.dersAdi,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )));
                      }).toList(),
                    )
                  ])),
            ]));
          }
        });
  }
}
