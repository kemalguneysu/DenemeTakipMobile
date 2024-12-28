import 'package:mobil_denemetakip/components/home/authenticated/ayt-card.dart';
import 'package:mobil_denemetakip/components/home/authenticated/countDownTimer.dart';
import 'package:mobil_denemetakip/components/home/authenticated/tyt-card.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
class AuthenticatedHome extends StatefulWidget {
  @override
  _AuthenticatedHomeState createState() => _AuthenticatedHomeState();
}

class _AuthenticatedHomeState extends State<AuthenticatedHome> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CountDownTimer(),
          TytCard(),
          AytCard()
        ],
      )
    );
  }
}