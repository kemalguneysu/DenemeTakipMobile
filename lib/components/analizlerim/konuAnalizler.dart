import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/deneme-service.dart';
import 'package:mobil_denemetakip/services/dersler-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class KonuAnalizler extends StatefulWidget {
  const KonuAnalizler({super.key});

  @override
  State<KonuAnalizler> createState() => _KonuAnalizlerState();
}

class _KonuAnalizlerState extends State<KonuAnalizler> {
  ValueNotifier<int> denemeSayisi = ValueNotifier(5);
  ValueNotifier<int> konuSayisi = ValueNotifier(5);

  ValueNotifier<bool> isAyt = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isLoadingForChart = ValueNotifier(false);
  ValueNotifier<String?> dersId = ValueNotifier(null);
  ValueNotifier<String> alanTur = ValueNotifier("sayisal");
  ValueNotifier<List<Ders>> dersler = ValueNotifier([]);
  final ValueNotifier<List<DenemeAnaliz>> analiz =
      ValueNotifier<List<DenemeAnaliz>>([]);
  final alanlar = ["Sayısal", "Eşit Ağırlık", "Sözel", "Dil"];
  ValueNotifier<String> type = ValueNotifier("yanlis");

  final derslerService = DerslerService();
  final denemelerService = DenemeService();

  Future<void> _fetchDersler() async {
    isLoading.value = true;
    try {
      // Dersler verisini almak
      final data = await derslerService.getAllDers(isTyt: !isAyt.value);

      if (data['dersler'] is List) {
        List<Ders> allDersler = data['dersler'] as List<Ders>;

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
        dersId.value = allDersler[0].id;
      } else {
        throw Exception("Dersler verisi gelirken bir hata ile karşılaşıldı.");
      }
    } catch (error) {
      if (mounted) {
        // errorToast("Hata", error.toString(), Navigator.of(context).context);
      }
    } finally {
      isLoading.value = false;
    }
  }

  String getDersAdi() {
    try {
      if (dersId.value == null || dersler.value.isEmpty) {
        return "seçili ders";
      }
      return dersler.value
          .firstWhere(
            (d) => d.id == dersId.value,
            orElse: () => Ders(id: "", dersAdi: "seçili ders",isTyt: true),
          )
          .dersAdi;
    } catch (e) {
      return "seçili ders";
    }
  }

  Future<void> _fetchAnaliz() async {
    if (dersId.value == null) return;
    isLoadingForChart.value = true;
    try {
      final data = !isAyt.value
          ? await denemelerService.getTytAnaliz(
              denemeSayisi: denemeSayisi.value,
              konuSayisi: konuSayisi.value,
              dersId: dersId.value!,
              type: type.value)
          : await denemelerService.getAytAnaliz(
              denemeSayisi: denemeSayisi.value,
              konuSayisi: konuSayisi.value,
              dersId: dersId.value!,
              type: type.value,
            );
      if (!mounted) return;
      analiz.value = data;
    } catch (error) {
      if (mounted) {
        errorToast("Hata", "$error", Navigator.of(context).context);
      }
    }
    isLoadingForChart.value = false;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchDersler();
      if (mounted) {
        await _fetchAnaliz();
      }
    });
  }
  @override
  void dispose() {
    denemeSayisi.dispose();
    konuSayisi.dispose();
    isAyt.dispose();
    isLoading.dispose();
    isLoadingForChart.dispose();
    dersId.dispose();
    alanTur.dispose();
    dersler.dispose();
    analiz.dispose();
    type.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dersler,
        builder: (context, derslerValue, child) {
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
                                  const SizedBox(height: 6),
                                  ValueListenableBuilder(
                                    valueListenable: analiz,
                                    builder: (context, analizList, child) {
                                      if (analizList == null)
                                        return Center(
                                          child: CircularProgressIndicator(
                                            size: 48,
                                          ),
                                        );
                                      return ValueListenableBuilder<int>(
                                        valueListenable: denemeSayisi,
                                        builder: (context, denemeSayisiValue,
                                            child) {
                                          return ValueListenableBuilder<
                                              String?>(
                                            valueListenable: dersId,
                                            builder:
                                                (context, dersIdValue, child) {
                                              final int analizSayisi =
                                                  analizList.length;
                                              final String ders =
                                                  (dersIdValue != null &&
                                                          dersIdValue
                                                              .isNotEmpty)
                                                      ? dersIdValue
                                                      : "Genel";
                                              return ValueListenableBuilder(
                                                  valueListenable: konuSayisi,
                                                  builder: (context,
                                                      konuSayisiValue, child) {
                                                    return Container(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 12),
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              "Son ${denemeSayisiValue} denemede ${getDersAdi()} dersi için en fazla "
                                                              "${
                                                                type.value == "yanlis"
                                                                    ? "yanlış"
                                                                    : "boş"
                                                              } yapılan ${analiz.value.length < konuSayisiValue ? analiz.value.length : konuSayisiValue} konu",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.symmetric(vertical: 16),
                                                            height: 300,
                                                            child: analiz.value
                                                                    .isNotEmpty
                                                                ? BarChart(
                                                                    BarChartData(
                                                                      alignment:
                                                                          BarChartAlignment
                                                                              .spaceAround,
                                                                      maxY: analiz
                                                                          .value
                                                                          .map((a) => a
                                                                              .sayi)
                                                                          .reduce((a, b) => a > b
                                                                              ? a
                                                                              : b)
                                                                          .toDouble(),
                                                                      barTouchData:
                                                                          BarTouchData(
                                                                        enabled:
                                                                            true,
                                                                        touchTooltipData:
                                                                            BarTouchTooltipData(
                                                                              fitInsideHorizontally: true,
                                                                              fitInsideVertically: true,
                                                                              tooltipRoundedRadius:8,
                                                                              tooltipMargin: 8,
                                                                              tooltipPadding: const EdgeInsets.all(8),
                                                                              maxContentWidth: 200,
                                                                              tooltipBorder: BorderSide(color: Theme.of(context).colorScheme.border,width: 1),
                                                                              getTooltipColor: (color) => Theme.of(context)
                                                                              .colorScheme
                                                                              .ring,
                                                                          getTooltipItem: (group,
                                                                              groupIndex,
                                                                              rod,
                                                                              rodIndex) {
                                                                            return BarTooltipItem(
                                                                              
                                                                              '${analiz.value[groupIndex].konuAdi}\n',
                                                                              TextStyle(
                                                                                color: Theme.of(context).colorScheme.background,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                              children: <TextSpan>[
                                                                                TextSpan(
                                                                                  text: '${analiz.value[groupIndex].sayi}',
                                                                                  style: const TextStyle(
                                                                                    fontSize: 16,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      titlesData:
                                                                          FlTitlesData(
                                                                        show:
                                                                            true,
                                                                        bottomTitles:
                                                                            AxisTitles(
                                                                          sideTitles:
                                                                              SideTitles(
                                                                            showTitles:
                                                                                true,
                                                                            getTitlesWidget:
                                                                                (value, meta) {
                                                                              if (value < 0 || value >= analiz.value.length) {
                                                                                return const Text('');
                                                                              }
                                                                              return Padding(
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: RotatedBox(
                                                                                  quarterTurns: 1,
                                                                                  child: Text(
                                                                                    analiz.value[value.toInt()].konuAdi,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                    textAlign: TextAlign.left,
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                            reservedSize:
                                                                                100,
                                                                          ),
                                                                        ),
                                                                        leftTitles:
                                                                            AxisTitles(
                                                                          sideTitles:
                                                                              SideTitles(
                                                                            showTitles:
                                                                                true,
                                                                            reservedSize:
                                                                                40,
                                                                          ),
                                                                        ),
                                                                        topTitles:
                                                                            AxisTitles(
                                                                          sideTitles:
                                                                              SideTitles(showTitles: false),
                                                                        ),
                                                                        rightTitles:
                                                                            AxisTitles(
                                                                          sideTitles:
                                                                              SideTitles(showTitles: false),
                                                                        ),
                                                                      ),
                                                                      borderData:
                                                                          FlBorderData(
                                                                        show:
                                                                            true,
                                                                        border: Border.all(
                                                                            color: Theme.of(context)
                                                                              .colorScheme
                                                                              .border,
                                                                        ),
                                                                      ),
                                                                      barGroups: analiz
                                                                          .value
                                                                          .asMap()
                                                                          .entries
                                                                          .map(
                                                                              (entry) {
                                                                        return BarChartGroupData(
                                                                          x: entry
                                                                              .key,
                                                                          barRods: [
                                                                            BarChartRodData(
                                                                              toY: entry.value.sayi.toDouble(),
                                                                              color: Theme.of(context).colorScheme.chart1,
                                                                              width: 22,
                                                                              borderRadius: BorderRadius.circular(4),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      }).toList(),
                                                                    ),
                                                                  )
                                                                : Center(
                                                                    child: Text(
                                                                      dersler.value.any((ders) =>
                                                                              ders.id ==
                                                                              dersIdValue) // dersin var olup olmadığını kontrol et
                                                                          ? "${dersler.value.firstWhere((ders) => ders.id == dersIdValue).dersAdi} dersi için ${type.value=="yanlis"?"yanlış":"boş"} konu bulunmamaktadır."
                                                                          : "Ders bulunamadı", 
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                          ),
                                                          Container(
                                                              child: Column(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8),
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      "Deneme Türü",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 8),
                                                                      width: double
                                                                          .infinity,
                                                                      child: OutlineButton(
                                                                          onPressed: () {
                                                                            showDropdown(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return DropdownMenu(children: [
                                                                                    MenuButton(
                                                                                      onPressed: (context) async {
                                                                                        setState(() {
                                                                                          isAyt.value = false;
                                                                                        });
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
                                                                          child: Text(isAyt.value ? "AYT" : "TYT", style: TextStyle(fontSize: 14), textAlign: TextAlign.left)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 8),
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                            "Konu Türü",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 8),
                                                                            width:
                                                                                double.infinity,
                                                                            child:
                                                                                OutlineButton(
                                                                              onPressed: () {
                                                                                showDropdown(
                                                                                  context: context,
                                                                                  builder: (context) {
                                                                                    return DropdownMenu(
                                                                                      children: [
                                                                                        MenuButton(
                                                                                          onPressed: (context) async {
                                                                                            setState(() {
                                                                                              type.value = "yanlis";
                                                                                            });
                                                                                            await _fetchAnaliz();
                                                                                          },
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                'Yanlış',
                                                                                                style: TextStyle(
                                                                                                  fontSize: 20,
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                ),
                                                                                              ),
                                                                                              if (type.value == "yanlis")
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(left: 8.0),
                                                                                                  child: Icon(
                                                                                                    LucideIcons.check,
                                                                                                    size: 20,
                                                                                                  ),
                                                                                                ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        MenuButton(
                                                                                          onPressed: (context) async {
                                                                                            setState(() {
                                                                                              type.value = "bos";
                                                                                            });
                                                                                            await _fetchAnaliz();
                                                                                          },
                                                                                          child: Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                                            children: [
                                                                                              Text(
                                                                                                'Boş',
                                                                                                style: TextStyle(
                                                                                                  fontSize: 20,
                                                                                                  fontWeight: FontWeight.w400,
                                                                                                ),
                                                                                              ),
                                                                                              if (type.value == "bos")
                                                                                                Padding(
                                                                                                  padding: const EdgeInsets.only(left: 8.0),
                                                                                                  child: Icon(
                                                                                                    LucideIcons.check,
                                                                                                    size: 20,
                                                                                                  ),
                                                                                                ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              },
                                                                              child: Text(
                                                                                type.value == "yanlis" ? "Yanlış" : "Boş",
                                                                                style: TextStyle(fontSize: 14),
                                                                                textAlign: TextAlign.left,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8),
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      "Deneme Sayısı",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 8),
                                                                      width: double
                                                                          .infinity,
                                                                      child: OutlineButton(
                                                                          onPressed: () {
                                                                            showDropdown(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return DropdownMenu(
                                                                                      children: [
                                                                                    5,
                                                                                    10,
                                                                                    15,
                                                                                    20,
                                                                                    30,
                                                                                    50
                                                                                  ].map((denemeSayisiSelected) {
                                                                                    return MenuButton(
                                                                                      onPressed: (context) async {
                                                                                        setState(() {
                                                                                          denemeSayisi.value = denemeSayisiSelected;
                                                                                        });
                                                                                        await _fetchAnaliz();
                                                                                      },
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
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
                                                                          child: Text(denemeSayisiValue.toString(), style: TextStyle(fontSize: 14), textAlign: TextAlign.left)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8),
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      "Konu Sayısı",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 8),
                                                                      width: double
                                                                          .infinity,
                                                                      child: OutlineButton(
                                                                          onPressed: () {
                                                                            showDropdown(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return DropdownMenu(
                                                                                      children: [
                                                                                    5,
                                                                                    10,
                                                                                    15,
                                                                                    20,
                                                                                  ].map((konuSayisiSelected) {
                                                                                    return MenuButton(
                                                                                      onPressed: (context) async {
                                                                                        setState(() {
                                                                                          konuSayisi.value = konuSayisiSelected;
                                                                                        });
                                                                                        await _fetchAnaliz();
                                                                                      },
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Text(
                                                                                            konuSayisiSelected.toString(),
                                                                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                                                                                          ),
                                                                                          if (konuSayisiValue == konuSayisiSelected)
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
                                                                          child: Text(konuSayisiValue.toString(), style: TextStyle(fontSize: 14), textAlign: TextAlign.left)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              isAyt.value
                                                                  ? Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 8),
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                            "Alan Türü",
                                                                            style:
                                                                                TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 8),
                                                                            width:
                                                                                double.infinity,
                                                                            child:
                                                                                OutlineButton(
                                                                              onPressed: () {
                                                                                showDropdown(
                                                                                    context: context,
                                                                                    builder: (context) {
                                                                                      return DropdownMenu(
                                                                                        children: alanlar.map((alan) {
                                                                                          return MenuButton(
                                                                                            onPressed: (context) async {
                                                                                              setState(() {
                                                                                                alanTur.value = setAlan(alan);
                                                                                              });
                                                                                              await _fetchDersler();
                                                                                              await _fetchAnaliz();
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
                                                                              child: ValueListenableBuilder(
                                                                                  valueListenable: alanTur,
                                                                                  builder: (context, alanTurValue, child) {
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
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 8),
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      "Dersler",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 8),
                                                                      width: double
                                                                          .infinity,
                                                                      child: OutlineButton(
                                                                          onPressed: () {
                                                                            showDropdown(
                                                                                context: context,
                                                                                builder: (context) {
                                                                                  return DropdownMenu(children: [
                                                                                    if (alanTur.value != "dil")
                                                                                      ...dersler.value.map((ders) {
                                                                                        return MenuButton(
                                                                                          onPressed: (context) async {
                                                                                            setState(() {
                                                                                              dersId.value = ders.id;
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
                                                                                              if (dersId.value == ders.id)
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
                                                                          child: Text(dersler.value.any((ders)=>ders.id==dersIdValue)?"${derslerValue.firstWhere((ders)=>ders.id==dersIdValue).dersAdi}":"${"Ders Bulunamadı."}", style: TextStyle(fontSize: 14), textAlign: TextAlign.left)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                        ],
                                                      ),
                                                    );
                                                  });
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
        });
  }
}
