import 'package:mobil_denemetakip/components/konu-takip/konu-takip.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class KonuTakipScreen extends StatefulWidget {
  const KonuTakipScreen({super.key});

  @override
  State<KonuTakipScreen> createState() => _KonuTakipScreenState();
}

class _KonuTakipScreenState extends State<KonuTakipScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            KonuTakip()
          ]
        )
      )
    );
  }
}