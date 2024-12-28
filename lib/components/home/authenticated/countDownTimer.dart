import 'dart:async';

import 'package:shadcn_flutter/shadcn_flutter.dart';

class CountDownTimer extends StatefulWidget {
  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  final DateTime targetDate = DateTime.utc(2025, 6, 21, 7, 15);
  late Timer _timer;
  late Duration _timeLeft;
  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeLeft();
    });
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    final difference = targetDate.difference(now);
    setState(() {
      _timeLeft = difference.isNegative ? Duration.zero : difference;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int days = _timeLeft.inDays;
    final int hours = _timeLeft.inHours % 24;
    final int minutes = _timeLeft.inMinutes % 60;
    return Container(
      width: double.infinity,
      child: Card(
        borderColor: Theme.of(context).colorScheme.border,
        borderWidth: 1,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
              "YKS'ye Kalan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeCard("Gün", days.toString()),
                _buildTimeCard("Saat", hours.toString()),
                _buildTimeCard("Dakika", minutes.toString()),
              ],
            ),
          ],
        ),
      ).intrinsic(),
    )
    ;
  }
}
Widget _buildTimeCard(String label, String value) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    ],
  );
}
