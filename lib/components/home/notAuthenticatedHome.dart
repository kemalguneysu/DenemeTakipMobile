import 'package:mobil_denemetakip/components/home/authenticated/countDownTimer.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class NotAuthenticatedHome extends StatefulWidget {
  @override
  _NotAuthenticatedHomeState createState() => _NotAuthenticatedHomeState();
}

class _NotAuthenticatedHomeState extends State<NotAuthenticatedHome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        CountDownTimer(),
      ],
    ));
  }
}
