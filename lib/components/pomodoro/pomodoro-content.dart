import 'package:mobil_denemetakip/components/pomodoro/pomodoro-links.dart';
import 'package:mobil_denemetakip/components/pomodoro/pomodoro-timer.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PomodoroContent extends StatefulWidget {
  const PomodoroContent({super.key});

  @override
  State<PomodoroContent> createState() => _PomodoroContentState();
}

class _PomodoroContentState extends State<PomodoroContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PomodoroTimer()
        ],
      ),
    );
  }
}