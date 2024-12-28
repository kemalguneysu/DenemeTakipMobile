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

class TytCard extends StatefulWidget {
  @override
  _TytCardState createState() => _TytCardState();
}

class _TytCardState extends State<TytCard> {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  final DenemeService _denemeService = DenemeService();
  SignalRService? signalRService;
  final authService = AuthService();
  HomePageTyt? _lastTyt;
  late DateTime denemeDate;

  @override
  void initState() {
    super.initState();
    _fetchLastTyt();
    signalRService = UseSignalR.of(context);
    final userId = authService.userId;
    signalRService!.on(HubUrls.TytHub.url, ReceiveFunctions.TytAddedMessage,
        (message) {
      _fetchLastTyt();
    }, userId: userId);
    signalRService!.on(HubUrls.TytHub.url, ReceiveFunctions.TytDeletedMessage,
        (message) {
      _fetchLastTyt();
    }, userId: userId);
    signalRService!.on(HubUrls.TytHub.url, ReceiveFunctions.TytUpdatedMessage,
        (message) {
      _fetchLastTyt();
    }, userId: userId);
  }

  Future<void> _fetchLastTyt() async {
    isLoading.value = true;
    try {
      final data = await _denemeService.getLastTyt();
      if (data == null) {
        _lastTyt = null;
        return;
      }
      setState(() {
        _lastTyt = HomePageTyt.fromJson(data);
        denemeDate = _lastTyt!.denemeDate;
      });
    } catch (error) {}
    finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    final userId = authService.userId;
    if (signalRService != null && userId != null) {
      signalRService!.off(HubUrls.TytHub.url, ReceiveFunctions.TytAddedMessage,
          userId: userId);
      signalRService!.off(
          HubUrls.TytHub.url, ReceiveFunctions.TytUpdatedMessage,
          userId: userId);
      signalRService!.off(
          HubUrls.TytHub.url, ReceiveFunctions.TytDeletedMessage,
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
            if (_lastTyt == null) {
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
                          "TYT denemeniz bulunmamaktadır.",
                          style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.centerRight,
                          child: PrimaryButton(
                          child: Text("TYT Denemesi Ekle",style: TextStyle(fontSize: 14),),
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
                              "Son TYT Denemesi",
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
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          child: Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Accordion(items: [
                                AccordionItem(
                                  trigger: AccordionTrigger(
                                    child: Text(
                                        "Türkçe Net: ${(_lastTyt!.turkceDogru - 0.25 * _lastTyt!.turkceYanlis).toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Türkçe Doğru: ${_lastTyt!.turkceDogru}",
                                          style: TextStyle(fontSize: 16)),
                                      Text(
                                          "Türkçe Yanlış: ${_lastTyt!.turkceYanlis}",
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                                AccordionItem(
                                  trigger: AccordionTrigger(
                                    child: Text(
                                        "Matematik Net: ${(_lastTyt!.matematikDogru - 0.25 * _lastTyt!.matematikYanlis).toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Matematik Doğru: ${_lastTyt!.matematikDogru}",
                                          style: TextStyle(fontSize: 16)),
                                      Text(
                                          "Matematik Yanlış: ${_lastTyt!.matematikYanlis}",
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                                AccordionItem(
                                  trigger: AccordionTrigger(
                                    child: Text(
                                        "Fen Net: ${(_lastTyt!.fenDogru - 0.25 * _lastTyt!.fenYanlis).toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Fen Doğru: ${_lastTyt!.fenDogru}",
                                          style: TextStyle(fontSize: 16)),
                                      Text("Fen Yanlış: ${_lastTyt!.fenYanlis}",
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                                AccordionItem(
                                  trigger: AccordionTrigger(
                                    child: Text(
                                        "Sosyal Net: ${(_lastTyt!.sosyalDogru - 0.25 * _lastTyt!.sosyalYanlis).toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Sosyal Doğru: ${_lastTyt!.sosyalDogru}",
                                          style: TextStyle(fontSize: 16)),
                                      Text(
                                          "Sosyal Yanlış: ${_lastTyt!.sosyalYanlis}",
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                )
                              ]),
                            )
                          ],
                        ),
                      )),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Text("Toplam Net: ${_lastTyt!.toplamNet}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        alignment: Alignment.bottomRight,
                        child: PrimaryButton(
                          child: Text("Detayları Gör"),
                          onPressed: () {
                            context.go("/denemelerim/tyt/${_lastTyt!.id}");
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
