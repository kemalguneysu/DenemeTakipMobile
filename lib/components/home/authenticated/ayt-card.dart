import 'package:go_router/go_router.dart';
import 'package:mobil_denemetakip/constants/hubUrls.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/receiveFunctions.dart';
import 'package:mobil_denemetakip/constants/spinner.dart';
import 'package:mobil_denemetakip/services/auth-service.dart';
import 'package:mobil_denemetakip/services/deneme-service.dart';
import 'package:mobil_denemetakip/services/signalr-service.dart';
import 'package:mobil_denemetakip/services/use-signalr.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:intl/intl.dart';

class AytCard extends StatefulWidget {
  @override
  _AytCardState createState() => _AytCardState();
}

class _AytCardState extends State<AytCard> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final DenemeService _denemeService = DenemeService();
  SignalRService? signalRService;
  final authService = AuthService();
  HomePageAyt? _lastAyt;
  late DateTime denemeDate;
  @override
  void initState() {
    super.initState();
    _fetchLastAyt();
    signalRService = UseSignalR.of(context);
    final userId = authService.userId;
    signalRService!.on(HubUrls.AytHub.url, ReceiveFunctions.AytAddedMessage,
        (message) {
      _fetchLastAyt();
    }, userId: userId);
    signalRService!.on(HubUrls.AytHub.url, ReceiveFunctions.AytDeletedMessage,
        (message) {
      _fetchLastAyt();
    }, userId: userId);
    signalRService!.on(HubUrls.AytHub.url, ReceiveFunctions.AytUpdatedMessage,
        (message) {
      _fetchLastAyt();
    }, userId: userId);
  }

  Future<void> _fetchLastAyt() async {
    isLoading.value = true;
    try {
      final data = await _denemeService.getLastAyt();
      setState(() {
        if(data==null){
          _lastAyt=null;
          return;
        }
        _lastAyt = HomePageAyt.fromJson(data);
        denemeDate = _lastAyt!.denemeDate;
      });
    } catch (error) {}
    finally {
      isLoading.value = false;
    }
  }

  String formatValue(double value) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }
  @override
  void dispose() {
    final userId = authService.userId;
    if (signalRService != null && userId != null) {
      signalRService!.off(HubUrls.AytHub.url, ReceiveFunctions.AytAddedMessage,
          userId: userId);
      signalRService!.off(
          HubUrls.AytHub.url, ReceiveFunctions.AytUpdatedMessage,
          userId: userId);
      signalRService!.off(
          HubUrls.AytHub.url, ReceiveFunctions.AytDeletedMessage,
          userId: userId);
    }
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
            if (_lastAyt == null) {
              return Container(
                  margin: const EdgeInsets.only(top: 24),
                  width: double.infinity,
                  child: Card(
                    borderColor: Theme.of(context).colorScheme.border,
                    borderWidth: 1,
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "AYT denemeniz bulunmamaktadır.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.centerRight,
                          child: PrimaryButton(
                            child: Text(
                              "AYT Denemesi Ekle",
                              style: TextStyle(fontSize: 14),
                            ),
                            onPressed: () {
                              context.go("/denemelerim");
                            },
                          ),
                        ),
                      ],
                    )).intrinsic(),
                  ));
            }
            return Container(
              margin: const EdgeInsets.only(top: 24),
              width: double.infinity,
              child: Card(
                borderColor: Theme.of(context).colorScheme.border,
                borderWidth: 1,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Son AYT Denemesi",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 5),
                            Opacity(
                              opacity: 0.6,
                              child: Text(
                                DateFormat('dd/MM/yyyy').format(denemeDate),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Accordion(
                                items: [
                                  AccordionItem(
                                    trigger: AccordionTrigger(
                                      child: Text(
                                          "Sayısal Net: ${formatValue(_lastAyt!.sayisalNet)}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Matematik Net: ${formatValue(_lastAyt!.matematikDogru - 0.25 * _lastAyt!.matematikYanlis)}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Doğru: ${_lastAyt!.matematikDogru}",
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                        "Yanlış: ${_lastAyt!.matematikYanlis}",
                                                        style: TextStyle(
                                                            fontSize: 14)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Fizik Net: ${formatValue(_lastAyt!.fizikDogru - 0.25 * _lastAyt!.fizikYanlis)}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Doğru: ${_lastAyt!.fizikDogru}",
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                        "Yanlış: ${_lastAyt!.fizikYanlis}",
                                                        style: TextStyle(
                                                            fontSize: 14)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Kimya Net: ${formatValue(_lastAyt!.kimyaDogru - 0.25 * _lastAyt!.kimyaYanlis)}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Doğru: ${_lastAyt!.kimyaDogru}",
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                        "Yanlış: ${_lastAyt!.kimyaYanlis}",
                                                        style: TextStyle(
                                                            fontSize: 14)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Biyoloji Net: ${formatValue(_lastAyt!.biyolojiDogru - 0.25 * _lastAyt!.biyolojiYanlis)}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Doğru: ${_lastAyt!.biyolojiDogru}",
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                        "Yanlış: ${_lastAyt!.biyolojiYanlis}",
                                                        style: TextStyle(
                                                            fontSize: 14)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AccordionItem(
                                  trigger: AccordionTrigger(
                                    child: Text(
                                      "Eşit Ağırlık Net: ${formatValue(_lastAyt!.esitAgirlikNet)}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    children: [
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Edebiyat Net: ${formatValue(_lastAyt!.edebiyatDogru - 0.25 * _lastAyt!.edebiyatYanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.edebiyatDogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.edebiyatYanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Matematik Net: ${formatValue(_lastAyt!.matematikDogru - 0.25 * _lastAyt!.matematikYanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.matematikDogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.matematikYanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Tarih1 Net: ${formatValue(_lastAyt!.tarih1Dogru - 0.25 * _lastAyt!.tarih1Yanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.tarih1Dogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.tarih1Yanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Coğrafya1 Net: ${formatValue(_lastAyt!.cografya1Dogru - 0.25 * _lastAyt!.cografya1Yanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.cografya1Dogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.cografya1Yanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    ],
                                  ),
                                  ),
                                  AccordionItem(
                                  trigger: AccordionTrigger(
                                    child: Text(
                                      "Sözel Net: ${formatValue(_lastAyt!.sozelNet)}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    children: [
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Edebiyat Net: ${formatValue(_lastAyt!.edebiyatDogru - 0.25 * _lastAyt!.edebiyatYanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.edebiyatDogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.edebiyatYanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Tarih1 Net: ${formatValue(_lastAyt!.tarih1Dogru - 0.25 * _lastAyt!.tarih1Yanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.tarih1Dogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.tarih1Yanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Coğrafya1 Net: ${formatValue(_lastAyt!.cografya1Dogru - 0.25 * _lastAyt!.cografya1Yanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.cografya1Dogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.cografya1Yanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Tarih2 Net: ${formatValue(_lastAyt!.tarih2Dogru - 0.25 * _lastAyt!.tarih2Yanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.tarih2Dogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.tarih2Yanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Coğrafya2 Net: ${formatValue(_lastAyt!.cografya2Dogru - 0.25 * _lastAyt!.cografya2Yanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.cografya2Dogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.cografya2Yanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Felsefe Net: ${formatValue(_lastAyt!.felsefeDogru - 0.25 * _lastAyt!.felsefeYanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.felsefeDogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.felsefeYanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Din Net: ${formatValue(_lastAyt!.dinDogru - 0.25 * _lastAyt!.dinYanlis)}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                            FontWeight.w600),
                                        ),
                                        Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          children: [
                                          Text(
                                            "Doğru: ${_lastAyt!.dinDogru}",
                                            style: TextStyle(
                                              fontSize: 14),
                                          ),
                                          Text(
                                            "Yanlış: ${_lastAyt!.dinYanlis}",
                                            style: TextStyle(
                                              fontSize: 14)),
                                          ],
                                        ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    ],
                                  ),
                                  ),
                                  AccordionItem(
                                  trigger: AccordionTrigger(
                                    child: Text(
                                      "Dil Net: ${formatValue(_lastAyt!.dilNet)}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600)),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                    children: [
                                    Container(
                                      margin:
                                        const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                      crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        "Doğru: ${_lastAyt!.dilDogru}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                        "Yanlış: ${_lastAyt!.dilYanlis}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          ),
                                        ),
                                      ],
                                      ),
                                    ),
                                    ],
                                  ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        alignment: Alignment.bottomRight,
                        child: PrimaryButton(
                          child: Text("Detayları Gör",style: TextStyle(fontSize: 14),),
                          onPressed: () {
                            context.go("/denemelerim/Ayt/${_lastAyt!.id}");
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ).intrinsic(),
            );
          }
        });
  }
}
