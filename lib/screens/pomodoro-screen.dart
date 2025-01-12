import 'package:flutter/material.dart';
import 'package:mobil_denemetakip/components/pomodoro/pomodoro-content.dart';

class PomodoroScreen extends StatelessWidget {
  const PomodoroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child:PomodoroContent()
    );
  }
}
