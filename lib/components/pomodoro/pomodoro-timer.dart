import 'package:lucide_icons/lucide_icons.dart';
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  ValueNotifier<List<PomodoroSession>> sessions = ValueNotifier([]);
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<double> volume = ValueNotifier(1.0);
  ValueNotifier<bool> autoStartBreaks = ValueNotifier(false);
  ValueNotifier<bool> autoStartSession = ValueNotifier(false);
  ValueNotifier<bool> isRunning = ValueNotifier(false);
   ValueNotifier<int> timer = ValueNotifier<int>(0);

  final TextEditingController sessionNameController = TextEditingController();
  final TextEditingController sessionMinutesController =TextEditingController();
  final TextEditingController sessionSecondsController =TextEditingController();
  final TextEditingController breakMinutesController = TextEditingController();
  final TextEditingController breakSecondsController = TextEditingController();

  final TextEditingController fastSessionMinutesController =TextEditingController();
  final TextEditingController fastSessionSecondsController =TextEditingController();
  final TextEditingController fastBreakMinutesController = TextEditingController();
  final TextEditingController fastBreakSecondsController = TextEditingController();
  final TextEditingController fastSessionCountController = TextEditingController();
  ValueNotifier<bool> startSessionAutomatically = ValueNotifier(false);
  ValueNotifier<bool> startBreakAutomatically = ValueNotifier(false);


  SliderValue sliderValue = const SliderValue.single(1);
  ValueNotifier<int> volumePercentage = ValueNotifier(100);

  final CountDownController _countDownController = CountDownController();
  Timer? _timer;
  double percentage = 0;

  final List<AudioOption> audioOptions = [
    AudioOption(name: "classic-alarm", file: "assets/audio/classic-alarm.wav"),
    AudioOption(name: "beep-alarm", file: "assets/audio/beep-alarm.mp3"),
    AudioOption(name: "whistling-alarm", file: "assets/audio/whistling-alarm.mp3"),
    AudioOption(name: "raven-alarm", file: "assets/audio/raven-alarm.mp3"),
    AudioOption(name: "digital-alarm", file: "assets/audio/digital-alarm.mp3"),
  ];

  Map<String, AudioPlayer> audios = {};
  AudioPlayer? selectedAlarmSound;
  Timer? _alarmTimer;
  AudioPlayer? _currentPlayer;
  bool isAlarmPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      // Önce mevcut AudioPlayer'ları temizle
      for (var player in audios.values) {
        await player.dispose();
      }
      audios.clear();
      selectedAlarmSound = null;

      // Her ses için yeni AudioPlayer oluştur
      for (var audio in audioOptions) {
        final player = AudioPlayer();
        await player.setAsset(audio.file);
        audios[audio.name] = player;
      }

      final prefs = await SharedPreferences.getInstance();
      
      // Kayıtlı ses ayarını yükle
      final savedAlarmName = prefs.getString('selectedAlarmSound');
      if (savedAlarmName != null && audios.containsKey(savedAlarmName)) {
        selectedAlarmSound = audios[savedAlarmName];
      } else {
        selectedAlarmSound = audios["classic-alarm"];
        await prefs.setString('selectedAlarmSound', "classic-alarm");
      }

      // Kayıtlı ses seviyesini yükle
      final savedLevel = prefs.getDouble('alarmSoundLevel');
      if (savedLevel != null) {
        sliderValue = SliderValue.single(savedLevel);
        volumePercentage.value = (savedLevel * 100).toInt();
      } else {
        sliderValue = const SliderValue.single(1.0);
        await prefs.setDouble('alarmSoundLevel', 1.0);
      }
    } catch (e) {
      print('Audio initialization error: $e');
    }
  }

  Future<String?> _loadSavedAlarmSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedAlarmSound');
  }

  Future<double?> _loadSavedVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('alarmVolume');
  }

  Future<void> _saveAlarmSound(String soundName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAlarmSound', soundName);
  }

  Future<void> _saveVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('alarmVolume', volume);
  }

  void addSession() {
    final int sessionMinutes = int.tryParse(sessionMinutesController.text) ?? 0;
    final int sessionSeconds = int.tryParse(sessionSecondsController.text) ?? 0;
    final int breakMinutes = int.tryParse(breakMinutesController.text) ?? 0;
    final int breakSeconds = int.tryParse(breakSecondsController.text) ?? 0;

    final int totalSessionTime = sessionMinutes * 60 + sessionSeconds;
    final int totalBreakTime = breakMinutes * 60 + breakSeconds;

    // Eğer oturum süresi ve ara süresi sıfırsa işlem durdur
    if (!(totalSessionTime > 0) && totalBreakTime > 0) {
      return;
    }

    // Yeni oturum oluştur
    final newSession = PomodoroSession(
      id: sessions.value.length + 1,
      oturumAdi: sessionNameController.text.isNotEmpty
          ? sessionNameController.text
          : 'Oturum ${sessions.value.length + 1}',
      oturumSuresi: totalSessionTime,
      araSuresi: totalBreakTime,
      durum: 'waiting',
    );

    // İlk session veya tüm sessionlar played ise yeni session'ı başlat
    if (sessions.value.isEmpty || 
        sessions.value.every((session) => session.durum == "played")) {
      currentIndex.value = sessions.value.length;
      timer.value = totalSessionTime;
    }

    sessions.value = [...sessions.value, newSession];
    updatePercentage();
    setState(() {});
  }
  void removeSession(int index) {
    sessions.value.removeAt(index);
  }
  void handleHizliOturum() {
    final int sessionMinutes =
        int.tryParse(fastSessionMinutesController.text) ?? 0;
    final int sessionSeconds =
        int.tryParse(fastSessionSecondsController.text) ?? 0;
    final int breakMinutes = int.tryParse(fastBreakMinutesController.text) ?? 0;
    final int breakSeconds = int.tryParse(fastBreakSecondsController.text) ?? 0;
    final int sessionCount =
        int.tryParse(fastSessionCountController.text) ?? 1;

    final int totalSessionTime = sessionMinutes * 60 + sessionSeconds;
    final int totalBreakTime = breakMinutes * 60 + breakSeconds;

    if (!(totalSessionTime > 0) || !(totalBreakTime > 0)) return;

    final List<PomodoroSession> newSessions = List.generate(
      sessionCount,
      (index) => PomodoroSession(
        id: sessions.value.length + index + 1,
        oturumAdi: "Oturum ${index + 1}",
        oturumSuresi: totalSessionTime,
        araSuresi: totalBreakTime,
        durum: "waiting",
      ),
    );

    setState(() {
      currentIndex.value = 0;
      timer.value = totalSessionTime;

      final bool allSessionsPlayed =
          sessions.value.every((session) => session.durum == "played");

      if (allSessionsPlayed) {
        currentIndex.value = sessions.value.length; 
        timer.value = totalSessionTime; 
      }

      sessions.value = newSessions;
    }
    );
  }

  String formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  TableCell buildHeaderCell(String text, [bool alignRight = false]) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: alignRight ? Alignment.centerRight : Alignment.center,
        child: Text(text).muted().semiBold(),
      ),
    );
  }
  TableCell buildCell(
    String text, [
    bool alignRight = false,
    bool isIcon = false,
    String? state,
  ]) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        alignment: alignRight ? Alignment.centerRight : Alignment.center,
        child: isIcon ? getIconForState(state ?? "") : Text(text),
      ),
    );
  }
  Widget? getIconForState(String state) {
    switch (state) {
      case "played":
        return Icon(LucideIcons.check);
      case "playing":
        return Icon(LucideIcons.play);
      case "break":
        return Icon(LucideIcons.play);
      case "waiting":
        return Icon(LucideIcons.timer);
      case "paused":
        return Icon(LucideIcons.pause);
      default:
        return null;
    }
  }

  String getCurrentSessionName() {
    if (sessions.value.isEmpty || currentIndex.value >= sessions.value.length) {
      return "Oturum Yok";
    }
    
    var session = sessions.value[currentIndex.value];
    bool isBreak = session.durum == "break";
    return isBreak ? "${session.oturumAdi} Ara" : session.oturumAdi;
  }

  int getCurrentDuration() {
    if (sessions.value.isEmpty || currentIndex.value >= sessions.value.length) {
      return 0;
    }
    
    var session = sessions.value[currentIndex.value];
    return session.durum == "break" ? session.araSuresi : session.oturumSuresi;
  }

  void startTimer() {
    if (sessions.value.isEmpty || currentIndex.value >= sessions.value.length) {
      return;
    }

    isRunning.value = true;
    var session = sessions.value[currentIndex.value];
    
    // Durum kontrolü
    if (session.durum == "waiting" || session.durum == "paused") {
      // Timer değerine göre durumu ayarla
      if (timer.value == session.araSuresi) {
        session.durum = "break";
      } else {
        session.durum = "playing";
      }
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (this.timer.value <= 0) {
          timer.cancel();
          isRunning.value = false;
          onComplete(); // Timer bitince onComplete'i çağır
        } else {
          this.timer.value--;
          updatePercentage();
        }
      });
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    isRunning.value = false;
    if (sessions.value.isNotEmpty && currentIndex.value < sessions.value.length) {
      sessions.value[currentIndex.value].durum = "paused";
    }
    setState(() {});
  }

  void updatePercentage() {
    if (sessions.value.isEmpty || currentIndex.value >= sessions.value.length) {
      percentage = 0;
      return;
    }

    var currentSession = sessions.value[currentIndex.value];
    int totalDuration = currentSession.durum == "break" 
        ? currentSession.araSuresi 
        : currentSession.oturumSuresi;

    percentage = totalDuration > 0 ? (timer.value / totalDuration) * 100 : 0;
  }

  void onComplete() {
    var currentSession = sessions.value[currentIndex.value];
    
    // Önce alarmı çal
    playAlarmSound();
    
    // 5 saniye bekle ve sonra geçiş yap
    Future.delayed(const Duration(seconds: 5), () {
      if (currentSession.durum == "playing") {
        timer.value = currentSession.araSuresi;
        currentSession.durum = "break";
        if (startBreakAutomatically.value) {
          startTimer();
        }
      } else if (currentSession.durum == "break") {
        currentSession.durum = "played";
        if (currentIndex.value < sessions.value.length - 1) {
          currentIndex.value++;
          var nextSession = sessions.value[currentIndex.value];
          timer.value = nextSession.oturumSuresi;
          nextSession.durum = "waiting";
          if (startSessionAutomatically.value) {
            startTimer();
          }
        }
      }
      setState(() {});
    });
  }

  void handleForward() {
    _timer?.cancel();
    isRunning.value = false;

    if (sessions.value.isEmpty || currentIndex.value >= sessions.value.length) {
      return;
    }

    var currentSession = sessions.value[currentIndex.value];
    
    if (currentSession.durum == "playing" || currentSession.durum == "paused") {
      // Oturumdan ara süresine geç
      timer.value = currentSession.araSuresi;
      currentSession.durum = "break";
      if (autoStartBreaks.value) {
        startTimer();
      }
    } else if (currentSession.durum == "break") {
      // Ara süresinden sonraki oturuma geç
      currentSession.durum = "played";
      if (currentIndex.value < sessions.value.length - 1) {
        currentIndex.value++;
        var nextSession = sessions.value[currentIndex.value];
        timer.value = nextSession.oturumSuresi;
        nextSession.durum = "waiting";
        if (autoStartSession.value) {
          startTimer();
        }
      }
    }
    setState(() {});
  }

  void handleRestart() {
    if (sessions.value.isEmpty || currentIndex.value >= sessions.value.length) {
      return;
    }

    _timer?.cancel();
    var currentSession = sessions.value[currentIndex.value];
    
    // Mevcut duruma göre süreyi sıfırla
    if (currentSession.durum == "break") {
      timer.value = currentSession.araSuresi;
    } else {
      timer.value = currentSession.oturumSuresi;
    }
    
    pauseTimer();
    updatePercentage();
    setState(() {});
  }

  void playAlarmSound({bool isTest = false}) async {
    if (selectedAlarmSound == null) return;

    try {
      // Önce mevcut alarmı temizle
      await _stopAlarm();

      // Yeni alarmı başlat
      await selectedAlarmSound!.setVolume(sliderValue.value);
      await selectedAlarmSound!.seek(Duration.zero);
      await selectedAlarmSound!.play();
      isAlarmPlaying = true;

      // Timer'ı başlat
      _startAlarmTimer(isTest: isTest);
    } catch (e) {
      print('Audio play error: $e');
      await _stopAlarm();
    }
  }


  // Yeni metod: Mevcut alarmı güvenli bir şekilde durdurma
 void stopCurrentAlarm() {
    _alarmTimer?.cancel();
    _alarmTimer = null;

    if (selectedAlarmSound?.playing ?? false) {
      selectedAlarmSound!.stop();
    }
    isAlarmPlaying = false;
  }

   void _startAlarmTimer({bool isTest = false}) {
    _alarmTimer?.cancel();
    _alarmTimer = Timer(Duration(seconds: isTest ? 1 : 5), () async {
      await _stopAlarm();
    });
  }

  void _restartAlarmTimer({bool isTest = false}) {
    _alarmTimer?.cancel();
    _startAlarmTimer(isTest: isTest);
  }

  Future<void> _stopAlarm() async {
    _alarmTimer?.cancel();
    _alarmTimer = null;

    if (selectedAlarmSound != null) {
      try {
        if (selectedAlarmSound!.playing) {
          await selectedAlarmSound!.pause();
          await selectedAlarmSound!.seek(Duration.zero);
        }
      } catch (e) {
        print('Stop alarm error: $e');
      }
    }
    isAlarmPlaying = false;
  }

  void changeAlarmSound(String newSoundName) async {
    if (!audios.containsKey(newSoundName)) return;

    // Önce mevcut alarmı durdur
    await _stopAlarm();

    // Yeni alarmı seç ve kaydet
    setState(() {
      selectedAlarmSound = audios[newSoundName];
    });

    // Tercihleri kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedAlarmSound', newSoundName);

    // Yeni alarmı çal
    playAlarmSound(isTest: false);
  }

  void onSliderChange(double newValue) async {
    // Slider değerini güncelle
    setState(() {
      sliderValue = SliderValue.single(newValue);
      volumePercentage.value = (newValue * 100).toInt();
    });

    // Tercihleri kaydet
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('alarmSoundLevel', newValue);

    // Eğer alarm çalıyorsa, ses seviyesini güncelle
    if (isAlarmPlaying && selectedAlarmSound != null) {
      await selectedAlarmSound!.setVolume(newValue);
    } else {
      // Alarm çalmıyorsa yeni ses seviyesiyle çal
      playAlarmSound(isTest: false);
    }
  }

    @override
  void dispose() {
    _stopAlarm();
    for (var player in audios.values) {
      player.dispose();
    }
    audios.clear();
    selectedAlarmSound = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PomodoroSession>>(
        valueListenable: sessions,
        builder: (context, sessionList, child) {
          return Container(
              child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getCurrentSessionName(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: SizedBox(
                        width: 220,
                        height: 220,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: percentage / 100,
                            ),
                            Center(
                              child: Text(
                                formatTime(timer.value),
                                style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.rotateCcw),
                          variance: ButtonVariance.ghost,
                          onPressed: handleRestart,
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: Icon(
                            isRunning.value ? LucideIcons.pause : LucideIcons.play,
                          ),
                          variance: ButtonVariance.ghost,
                          onPressed: () {
                            if (isRunning.value) {
                              pauseTimer();
                            } else {
                              startTimer();
                            }
                          },
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          variance: ButtonVariance.ghost,
                          icon: const Icon(LucideIcons.skipForward),
                          onPressed: handleForward,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PrimaryButton(
                    onPressed: () {
                      showPopover(
                          context: context,
                          alignment: Alignment.topCenter,
                          builder: (context) {
                            return SizedBox(
                              height: 300,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Hızlı Oturum Ekle",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        IconButton(
                                          variance: ButtonVariance.ghost,
                                          icon: Icon(LucideIcons.x),
                                          onPressed: () =>
                                              closePopover(context),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: const [
                                        Text(
                                          "Oturum Süresi",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          "Ara Süresi",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      fastSessionMinutesController,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const Text(
                                                ':',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Flexible(
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      fastSessionSecondsController,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      fastBreakMinutesController,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const Text(
                                                ':',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              Flexible(
                                                child: TextField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      fastBreakSecondsController,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Oturum Sayısı",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      controller: fastSessionCountController,
                                      textAlign: TextAlign.center,
                                      initialValue: 1.toString(),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        PrimaryButton(
                                          onPressed: () {
                                            handleHizliOturum();
                                            closePopover(context);
                                          },
                                          child: const Text(
                                            'Oturumları Ekle',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Row(
                      children: [
                        Text(
                          "Hızlı Oturum",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Icon(
                          LucideIcons.plus,
                          size: 14,
                        )
                      ],
                    ),
                  ),
                  
                  PrimaryButton(
                    onPressed: () {
                      showPopover(
                        context: context,
                        alignment: Alignment.topCenter,
                        builder: (context) {
                          return SizedBox(
                            width: 300,
                            height: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Pomodoro Ayarları",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                      ),
                                      IconButton(
                                        variance: ButtonVariance.ghost,
                                        icon: Icon(LucideIcons.x),
                                        onPressed: () => closePopover(context),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    "Alarm Sesi",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Select<String>(
                                      itemBuilder: (context, item) => Text(item),
                                      popupConstraints: const BoxConstraints(
                                        maxHeight: 300,
                                        maxWidth: 200,
                                      ),
                                      onChanged: (value) async {
                                         if (value != null) {
                                           changeAlarmSound(value);
                                        }
                                      },
                                      placeholder: Text(audios.entries
                                          .firstWhere((entry) => entry.value == selectedAlarmSound,
                                              orElse: () => MapEntry('classic-alarm', selectedAlarmSound!))
                                          .key,style: TextStyle(fontSize: 14),),
                                      children: [
                                        SelectGroup(
                                          headers: const [SelectLabel(child: Text('Alarm Sesleri'))],
                                          children: audioOptions
                                              .map((audio) => SelectItemButton(
                                                    value: audio.name,
                                                    child: Text(audio.name,style: TextStyle(fontSize: 14),),
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    "Alarm Sesi Seviyesi",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Slider(
                                          value: sliderValue,
                                          onChanged: (newValue) async {
                                            setState(() {
                                              sliderValue = newValue;
                                            });
                                            volumePercentage.value = (newValue.value * 100).toInt();

                                            // Ses seviyesini kaydet
                                            final prefs = await SharedPreferences.getInstance();
                                            await prefs.setDouble('alarmSoundLevel', newValue.value);

                                            // Ses seviyesini test et
                                             onSliderChange(newValue.value);
                                          },
                                          min: 0,
                                          max: 1,
                                        ),
                                      ),
                                      ValueListenableBuilder<int>(
                                        valueListenable: volumePercentage,
                                        builder: (context, value, child) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                              '$value%',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Araları Otomatik Başlat",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: startBreakAutomatically,
                                        builder: (context, value, child) {
                                          return Switch(
                                            value: value,
                                            onChanged: (newValue) {
                                              startBreakAutomatically.value = newValue;
                                            }
                                          );
                                        }
                                      )
                                    ]
                                  ),
                                  SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Yeni Oturumu Otomatik Başlat",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: startSessionAutomatically,
                                        builder: (context, value, child) {
                                          return Switch(
                                            value: value,
                                            onChanged: (newValue) {
                                              startSessionAutomatically.value = newValue;
                                            }
                                          );
                                        }
                                      )
                                    ]
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          "Ayarlar",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Icon(
                          LucideIcons.settings,
                          size: 14,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text('Oturum Adı',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Oturum Süresi',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Ara Süresi',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sessionNameController,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: sessionMinutesController,
                          ),
                        ),
                        const Text(
                          ':',
                          style: TextStyle(fontSize: 16),
                        ),
                        Flexible(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: sessionSecondsController,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: breakMinutesController,
                          ),
                        ),
                        const Text(
                          ':',
                          style: TextStyle(fontSize: 16),
                        ),
                        Flexible(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: breakSecondsController,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Sağ tarafa yaslamak için
                children: [
                  PrimaryButton(
                    onPressed: () {
                      addSession();
                    },
                    child: const Text(
                      'Ekle',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              Container(
                  margin: EdgeInsets.only(top: 24),
                  child: Table(rows: [
                    TableRow(cells: [
                      buildHeaderCell("Oturum Adı"),
                      buildHeaderCell("Süre"),
                      buildHeaderCell("Ara Süresi"),
                      buildHeaderCell(
                        "Durum",
                      )
                    ]),
                    for (var session in sessionList)
                      TableRow(
                        cells: [
                          buildCell(session.oturumAdi),
                          buildCell(formatTime(session.oturumSuresi)),
                          buildCell(formatTime(session.araSuresi)),
                          buildCell(session.durum, false, true, session.durum),
                        ],
                      ),
                  ]))
            ],
          ));
        });
  }
}

class AudioOption {
  final String name;
  final String file;

  AudioOption({required this.name, required this.file});
}
