import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/deneme-service.dart';
import 'package:mobil_denemetakip/services/dersler-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class NetAnalizler extends StatefulWidget {
  const NetAnalizler({super.key});

  @override
  State<NetAnalizler> createState() => _NetAnalizlerState();
}

class _NetAnalizlerState extends State<NetAnalizler> {
  ValueNotifier<int> page = ValueNotifier(1);
  ValueNotifier<int> denemeSayisi = ValueNotifier(5);
  ValueNotifier<int> konuSayisi = ValueNotifier(5);

  ValueNotifier<bool> isAyt = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isLoadingForChart = ValueNotifier(false);
  ValueNotifier<String?> dersAdi = ValueNotifier(null);
  ValueNotifier<String> alanTur = ValueNotifier("sayisal");
  ValueNotifier<List<Ders>> dersler = ValueNotifier([]);
  final ValueNotifier<List<AnalysisResult>> analiz =
      ValueNotifier<List<AnalysisResult>>([]);
  final alanlar = ["Sayısal", "Eşit Ağırlık", "Sözel", "Dil"];

  final derslerService = DerslerService();
  final denemelerService = DenemeService();
  double findMax(){
    if(dersAdi.value!=null && dersAdi.value!.isNotEmpty){
      switch(dersAdi.value){
        case "Türkçe":
          return 40;
        case "Matematik":
          return 40;
        case "Fen":
          return 20;
        case "Sosyal":
          return 20;  
        case "Fizik":
          return 14;  
        case "Kimya":
          return 13; 
        case "Biyoloji":
          return 13; 
        case "Edebiyat":
          return 24;
        case "Tarih1":
          return 10;
        case "Coğrafya1":
          return 6;
        case "Tarih2":
          return 11;
        case "Coğrafya2":
          return 11;  
        case "Felsefe":
          return 12;
        case "Din":
          return 6; 
        case "Dil":
          return 80; 
      }
    }
    if(alanTur.value!=null && alanTur.value!.isNotEmpty && isAyt.value){
      return 80;
    }
    return 120;
    
  }
  Future<void> _fetchDersler() async {
    isLoading.value = true;
    try {
      // Dersler verisini almak
      final data = await derslerService.getAllDers(isTyt: !isAyt.value);

      if (data['dersler'] is List) {
        List<Ders> allDersler = data['dersler'] as List<Ders>;

        // Eğer AYT ise ve alanTur seçilmişse filtreleme yap
        if (isAyt.value && alanTur.value != null) {
          final Map<String, List<String>> alanDersler = {
            "sayisal": ["Matematik", "Fizik", "Kimya", "Biyoloji"],
            "esitagirlik": ["Matematik", "Edebiyat", "Tarih1", "Coğrafya1"],
            "sozel": [
              "Edebiyat",
              "Tarih1",
              "Coğrafya1",
              "Tarih2",
              "Coğrafya2",
              "Felsefe",
              "Din"
            ],
            "dil": ["Dil"]
          };

          final dersListesi = alanDersler[alanTur.value] ?? [];
          allDersler = allDersler
              .where((ders) => dersListesi.contains(ders.dersAdi))
              .toList();
        }

        dersler.value = allDersler;
      } else {
        throw Exception(
            "Dersler listesi bekleniyordu ancak alınan veri farklı.");
      }
    } catch (error) {
      if (mounted) {
        errorToast("Hata", error.toString(), Navigator.of(context).context);
      }
    } finally {
      isLoading.value = false;
    }
  }

  String getAlanAdi(String alan) {
    switch (alan) {
      case "sayisal":
        return "Sayısal";
      case "esitagirlik":
        return "Eşit Ağırlık";
      case "sozel":
        return "Sözel";
      case "dil":
        return "Dil";
      default:
        return "Sayısal";
    }
  }

  String setAlan(String alan) {
    switch (alan) {
      case "Sayısal":
        return "sayisal";
      case "Eşit Ağırlık":
        return "esitagirlik";
      case "Sözel":
        return "sozel";
      case "Dil":
        return "dil";
      default:
        return "sayisal";
    }
  }

  Future<void> _fetchAnaliz() async {
    isLoadingForChart.value = true;
    String dersAdiForBackend(String dersAdi) {
      switch (dersAdi) {
        case "Türkçe":
          return "turkce";
        case "Coğrafya1":
          return "cografya1";
        case "Coğrafya2":
          return "cografya2";
        default:
          return dersAdi;
      }
    }

    try {
      final data = !isAyt.value
          ? await denemelerService.getTytAnalysis(
              denemeSayisi: denemeSayisi.value,
              dersAdi: dersAdiForBackend(dersAdi.value ?? ""),
            )
          : await denemelerService.getAytAnalysis(
              denemeSayisi: denemeSayisi.value,
              alanTur: alanTur.value,
              dersAdi: dersAdiForBackend(dersAdi.value ?? ""),
            );
      analiz.value = data;
    } catch (error) {
      if (mounted) {
        errorToast("Hata", "$error", Navigator.of(context).context);
      }
    }
    isLoadingForChart.value = false;
  }

  LineTooltipItem getCustomTooltip(
    DateTime date,
    FlSpot touchedSpot,
    AnalysisResult data,
    bool isAyt,
    String? alanTur,
    String? dersAdi,
    ThemeData theme,
  ) {
    List<TextSpan> getTooltipContent() {
      List<TextSpan> content = [
        TextSpan(
          text: 'Net: ${touchedSpot.y.toStringAsFixed(2)}\n',
          style: TextStyle(
            color: theme.colorScheme.background,
            fontWeight: FontWeight.normal,
          ),
        ),
      ];

      if (!isAyt && dersAdi == null) {
        // TYT ve ders seçili değil
        if (data is TytAnalysis) {
          content.addAll([
            TextSpan(
                text: 'Türkçe Net: ${data.turkceNet.toStringAsFixed(2)}\n'),
            TextSpan(
                text:
                    'Matematik Net: ${data.matematikNet.toStringAsFixed(2)}\n'),
            TextSpan(text: 'Fen Net: ${data.fenNet.toStringAsFixed(2)}\n'),
            TextSpan(text: 'Sosyal Net: ${data.sosyalNet.toStringAsFixed(2)}'),
          ]);
        }
      } else if (!isAyt && dersAdi != null) {
        // TYT ve ders seçili
        if (data is BaseAnalysis) {
          content.addAll([
            TextSpan(text: 'Doğru: ${data.dogru}\n'),
            TextSpan(text: 'Yanlış: ${data.yanlis}'),
          ]);
        }
      } else if (isAyt && alanTur == "sayisal" && dersAdi == null) {
        // AYT Sayısal
        if (data is SayisalAnalysis) {
          content.addAll([
            TextSpan(
                text:
                    'Matematik Net: ${data.matematikNet.toStringAsFixed(2)}\n'),
            TextSpan(text: 'Fizik Net: ${data.fizikNet.toStringAsFixed(2)}\n'),
            TextSpan(text: 'Kimya Net: ${data.kimyaNet.toStringAsFixed(2)}\n'),
            TextSpan(
                text: 'Biyoloji Net: ${data.biyolojiNet.toStringAsFixed(2)}'),
          ]);
        }
      } else if (isAyt && alanTur == "esitagirlik" && dersAdi == null) {
        // AYT Eşit Ağırlık
        if (data is EsitAgirlikAnalysis) {
          content.addAll([
            TextSpan(
                text: 'Edebiyat Net: ${data.edebiyatNet.toStringAsFixed(2)}\n'),
            TextSpan(
                text:
                    'Matematik Net: ${data.matematikNet.toStringAsFixed(2)}\n'),
            TextSpan(
                text: 'Tarih1 Net: ${data.tarih1Net.toStringAsFixed(2)}\n'),
            TextSpan(
                text: 'Coğrafya1 Net: ${data.cografya1Net.toStringAsFixed(2)}'),
          ]);
        }
      } else if (isAyt && alanTur == "sozel" && dersAdi == null) {
        // AYT Sözel
        if (data is SozelAnalysis) {
          content.addAll([
            TextSpan(
                text: 'Edebiyat Net: ${data.edebiyatNet.toStringAsFixed(2)}\n'),
            TextSpan(
                text: 'Tarih1 Net: ${data.tarih1Net.toStringAsFixed(2)}\n'),
            TextSpan(
                text:
                    'Coğrafya1 Net: ${data.cografya1Net.toStringAsFixed(2)}\n'),
            TextSpan(
                text: 'Tarih2 Net: ${data.tarih2Net.toStringAsFixed(2)}\n'),
            TextSpan(
                text:
                    'Coğrafya2 Net: ${data.cografya2Net.toStringAsFixed(2)}\n'),
            TextSpan(
                text: 'Felsefe Net: ${data.felsefeNet.toStringAsFixed(2)}\n'),
            TextSpan(text: 'Din Net: ${data.dinNet.toStringAsFixed(2)}'),
          ]);
        }
      } else if (isAyt && (alanTur == "dil" || dersAdi != null)) {
        // AYT Dil veya herhangi bir ders seçili
        if (data is DilAnalysis || data is BaseAnalysis) {
          content.addAll([
            TextSpan(text: 'Doğru: ${(data as dynamic).dogru}\n'),
            TextSpan(text: 'Yanlış: ${(data as dynamic).yanlis}'),
          ]);
        }
      }

      return content;
    }

    return LineTooltipItem(
      'Tarih: ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}\n',
      TextStyle(
        color: theme.colorScheme.background,
        fontWeight: FontWeight.normal,
      ),
      children: getTooltipContent(),
      
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchDersler();
    _fetchAnaliz();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 24),
          width: double.infinity,
          child: Card(
            borderColor: Theme.of(context).colorScheme.border,
            borderWidth: 1,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder<bool>(
                              valueListenable: isAyt,
                              builder: (context, isAytValue, child) {
                                return Text(
                                  isAytValue
                                      ? "AYT Net Analizi"
                                      : "TYT Net Analizi",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            ValueListenableBuilder(
                              valueListenable: analiz,
                              builder: (context, analizList, child) {
                                return ValueListenableBuilder<int>(
                                  valueListenable: denemeSayisi,
                                  builder: (context, denemeSayisiValue, child) {
                                    return ValueListenableBuilder<String?>(
                                      valueListenable: dersAdi,
                                      builder: (context, dersAdiValue, child) {
                                        final int analizSayisi =
                                            analizList.length;
                                        final String ders =
                                            (dersAdiValue != null &&
                                                    dersAdiValue.isNotEmpty)
                                                ? dersAdiValue
                                                : "Genel";

                                        return Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Text(
                                                  "Son ${analizSayisi < denemeSayisiValue ? analizSayisi : denemeSayisiValue} "
                                                  "${isAyt.value ? "AYT denemesi için" : "TYT denemesi için"} $ders net analizi",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 16),
                                                child: ValueListenableBuilder(
                                                  valueListenable:
                                                      isLoadingForChart,
                                                  builder: (context, isLoading,
                                                      child) {
                                                    return ValueListenableBuilder(
                                                      valueListenable: analiz,
                                                      builder: (context,
                                                          List<AnalysisResult>
                                                              analizList,
                                                          child) {
                                                        if (isLoading) {
                                                          return Container(
                                                            height: 300,
                                                            child: Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                          );
                                                        }

                                                        if (analizList
                                                            .isEmpty) {
                                                          return Container(
                                                            height: 300,
                                                            child: Center(
                                                                child: Text(
                                                                    'Veri bulunamadı')),
                                                          );
                                                        }

                                                        double maxY = analizList
                                                            .map((e) => e.net)
                                                            .reduce((a, b) =>
                                                                a > b ? a : b);
                                                        double minY = 0;

                                                        return Container(
                                                          height: 300,
                                                          child: LineChart(
                                                            LineChartData(
                                                              gridData:
                                                                  FlGridData(
                                                                show: true,
                                                                drawVerticalLine:
                                                                    true,
                                                                getDrawingHorizontalLine:
                                                                    (value) {
                                                                  return FlLine(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .border,
                                                                    strokeWidth:
                                                                        1,
                                                                  );
                                                                },
                                                                getDrawingVerticalLine:
                                                                    (value) {
                                                                  return FlLine(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .border,
                                                                    strokeWidth:
                                                                        1,
                                                                  );
                                                                },
                                                              ),
                                                              titlesData:
                                                                  FlTitlesData(
                                                                leftTitles:
                                                                    AxisTitles(
                                                                  sideTitles:
                                                                      SideTitles(
                                                                    showTitles:
                                                                        true,
                                                                    reservedSize:
                                                                        40,
                                                                    getTitlesWidget:
                                                                        (value,
                                                                            meta) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                8.0),
                                                                        child:
                                                                            Text(
                                                                          value.toStringAsFixed(
                                                                              1),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Theme.of(context).colorScheme.primary,
                                                                            fontSize:
                                                                                12,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                bottomTitles:
                                                                    AxisTitles(
                                                                  sideTitles:
                                                                      SideTitles(
                                                                    showTitles:
                                                                        true,
                                                                    reservedSize:
                                                                        32,
                                                                    interval: (analizList.length /
                                                                            2)
                                                                        .ceil()
                                                                        .toDouble(),
                                                                    getTitlesWidget:
                                                                        (value,
                                                                            meta) {
                                                                      final index =
                                                                          value
                                                                              .toInt();
                                                                      if (index >=
                                                                              0 &&
                                                                          index <
                                                                              analizList.length) {
                                                                        final date =
                                                                            analizList[index].tarih;
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 8.0),
                                                                          child:
                                                                              Text(
                                                                            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year % 100}',
                                                                            style:
                                                                                TextStyle(
                                                                              color: Theme.of(context).colorScheme.primary,
                                                                              fontSize: 12,
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      return const Text(
                                                                          '');
                                                                    },
                                                                  ),
                                                                ),
                                                                rightTitles:
                                                                    AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                      showTitles:
                                                                          false),
                                                                ),
                                                                topTitles:
                                                                    AxisTitles(
                                                                  sideTitles: SideTitles(
                                                                      showTitles:
                                                                          false),
                                                                ),
                                                              ),
                                                              borderData:
                                                                  FlBorderData(
                                                                show: true,
                                                                border: Border(
                                                                  bottom:
                                                                      BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary,
                                                                    width: 1,
                                                                  ),
                                                                  left:
                                                                      BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .border,
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                              ),
                                                              minX: 0,
                                                              maxX: (analizList
                                                                          .length -
                                                                      1)
                                                                  .toDouble(),
                                                              minY: minY,
                                                              maxY: findMax(),
                                                              lineBarsData: [
                                                                LineChartBarData(
                                                                  spots: analizList
                                                                      .asMap()
                                                                      .entries
                                                                      .map(
                                                                          (entry) {
                                                                    return FlSpot(
                                                                      entry.key
                                                                          .toDouble(),
                                                                      entry
                                                                          .value
                                                                          .net,
                                                                    );
                                                                  }).toList(),
                                                                  isCurved:
                                                                      false,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .chart1,
                                                                  barWidth: 3,
                                                                  isStrokeCapRound:
                                                                      false,
                                                                  dotData:
                                                                      FlDotData(
                                                                    show: true,
                                                                    getDotPainter: (spot,
                                                                        percent,
                                                                        barData,
                                                                        index) {
                                                                      return FlDotCirclePainter(
                                                                        radius:
                                                                            4,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .chart2,
                                                                        strokeWidth:
                                                                            2,
                                                                        strokeColor: Theme.of(context)
                                                                            .colorScheme
                                                                            .foreground,
                                                                      );
                                                                    },
                                                                  ),
                                                                  belowBarData:
                                                                      BarAreaData(
                                                                    show: true,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary
                                                                        .withOpacity(
                                                                            0.1),
                                                                  ),
                                                                ),
                                                              ],
                                                              lineTouchData:
                                                                  LineTouchData(
                                                                enabled: true,
                                                                touchTooltipData:
                                                                    LineTouchTooltipData(
                                                                  getTooltipColor: (color)=>Theme.of(context).colorScheme.ring,
                                                                  tooltipBorder: BorderSide(color: Theme.of(context).colorScheme.border,width: 1),
                                                                  fitInsideHorizontally: true,
                                                                  fitInsideVertically: true,
                                                                  tooltipRoundedRadius:8,
                                                                  tooltipMargin: 8,
                                                                  tooltipPadding: const EdgeInsets.all(8),
                                                                  maxContentWidth: 200,
                                                                  getTooltipItems:
                                                                      (touchedSpots) {
                                                                    return touchedSpots
                                                                        .map(
                                                                            (touchedSpot) {
                                                                      final date = analizList[touchedSpot
                                                                              .x
                                                                              .toInt()]
                                                                          .tarih;
                                                                      final data =
                                                                          analizList[touchedSpot
                                                                              .x
                                                                              .toInt()];

                                                                      return getCustomTooltip(
                                                                        date,
                                                                        touchedSpot,
                                                                        data,
                                                                        isAyt
                                                                            .value,
                                                                        alanTur
                                                                            .value,
                                                                        dersAdi
                                                                            .value,
                                                                        Theme.of(
                                                                            context),
                                                                      );
                                                                    }).toList();
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              Container(
                                                  child: Column(
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 8),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Deneme Türü",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 8),
                                                          width:
                                                              double.infinity,
                                                          child: OutlineButton(
                                                              onPressed: () {
                                                                showDropdown(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return DropdownMenu(
                                                                          children: [
                                                                            MenuButton(
                                                                              onPressed: (context) async {
                                                                                setState(() {
                                                                                  isAyt.value = false;
                                                                                });
                                                                                dersAdi.value = null;
                                                                                await _fetchDersler();
                                                                                await _fetchAnaliz();
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    'TYT',
                                                                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                  if (!isAyt.value)
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 8.0),
                                                                                      child: Icon(LucideIcons.check, size: 20),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            MenuButton(
                                                                                onPressed: (context) async {
                                                                                  setState(() {
                                                                                    isAyt.value = true;
                                                                                  });
                                                                                  dersAdi.value = null;
                                                                                  await _fetchDersler();
                                                                                  await _fetchAnaliz();
                                                                                },
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text('AYT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                                                                                    if (isAyt.value)
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 8.0),
                                                                                        child: Icon(
                                                                                          LucideIcons.check,
                                                                                          size: 20,
                                                                                        ),
                                                                                      ),
                                                                                  ],
                                                                                )),
                                                                          ]);
                                                                    });
                                                              },
                                                              child: Text(
                                                                  isAyt.value
                                                                      ? "AYT"
                                                                      : "TYT",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  isAyt.value
                                                      ? Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 8),
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Alan Türü",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8),
                                                                width: double
                                                                    .infinity,
                                                                child:
                                                                    OutlineButton(
                                                                  onPressed:
                                                                      () {
                                                                    showDropdown(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (context) {
                                                                          return DropdownMenu(
                                                                            children:
                                                                                alanlar.map((alan) {
                                                                              return MenuButton(
                                                                                onPressed: (context) async {
                                                                                  setState(() {
                                                                                    alanTur.value = setAlan(alan);
                                                                                  });
                                                                                  dersAdi.value=null;
                                                                                  await _fetchAnaliz();
                                                                                  await _fetchDersler();
                                                                                },
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      alan,
                                                                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                    if (getAlanAdi(alanTur.value) == alan)
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 8.0),
                                                                                        child: Icon(LucideIcons.check, size: 20),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                          );
                                                                        });
                                                                  },
                                                                  child:
                                                                      ValueListenableBuilder(
                                                                          valueListenable:
                                                                              alanTur,
                                                                          builder: (context,
                                                                              alanTurValue,
                                                                              child) {
                                                                            return Text(
                                                                              getAlanAdi(alanTurValue),
                                                                              style: TextStyle(
                                                                                fontSize: 14,
                                                                              ),
                                                                            );
                                                                          }),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : Container(),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 8),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Dersler",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 8),
                                                          width:
                                                              double.infinity,
                                                          child: OutlineButton(
                                                              onPressed: () {
                                                                showDropdown(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return DropdownMenu(
                                                                          children: [
                                                                            MenuButton(
                                                                              onPressed: (context) async {
                                                                                setState(() {
                                                                                  dersAdi.value = null;
                                                                                });
                                                                                await _fetchAnaliz();
                                                                              },
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    "Genel",
                                                                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                  if (dersAdi.value == null)
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(left: 8.0),
                                                                                      child: Icon(LucideIcons.check, size: 20),
                                                                                    ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            if(alanTur.value!="dil")
                                                                            ...dersler.value.map((ders) {
                                                                              return MenuButton(
                                                                                onPressed: (context) async {
                                                                                  setState(() {
                                                                                    dersAdi.value = ders.dersAdi;
                                                                                  });
                                                                                  await _fetchAnaliz();
                                                                                },
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      ders.dersAdi,
                                                                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                    if (dersAdi.value == ders.dersAdi)
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(left: 8.0),
                                                                                        child: Icon(LucideIcons.check, size: 20),
                                                                                      ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            }).toList(),
                                                                          ]);
                                                                    });
                                                              },
                                                              child: Text(
                                                                  dersAdiValue !=
                                                                          null
                                                                      ? dersAdiValue
                                                                      : "Genel",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        EdgeInsets.only(top: 8),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          "Deneme Sayısı",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 8),
                                                          width:
                                                              double.infinity,
                                                          child: OutlineButton(
                                                              onPressed: () {
                                                                showDropdown(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return DropdownMenu(
                                                                          children:
                                                                              [
                                                                        5,
                                                                        10,
                                                                        15,
                                                                        20,
                                                                        30,
                                                                        50
                                                                      ].map((denemeSayisiSelected) {
                                                                        return MenuButton(
                                                                          onPressed:
                                                                              (context) async {
                                                                            setState(() {
                                                                              denemeSayisi.value = denemeSayisiSelected;
                                                                            });
                                                                            await _fetchAnaliz();
                                                                          },
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                denemeSayisiSelected.toString(),
                                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                                                              ),
                                                                              if (denemeSayisiValue == denemeSayisiSelected)
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 8.0),
                                                                                  child: Icon(LucideIcons.check, size: 20),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        );
                                                                      }).toList());
                                                                    });
                                                              },
                                                              child: Text(
                                                                  denemeSayisiValue
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left)),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ))
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }
}
