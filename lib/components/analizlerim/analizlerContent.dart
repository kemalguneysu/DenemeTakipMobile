import 'package:mobil_denemetakip/components/analizlerim/konuAnalizler.dart';
import 'package:mobil_denemetakip/components/analizlerim/netAnalizler.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AnalizlerContent extends StatefulWidget {
  const AnalizlerContent({super.key});

  @override
  State<AnalizlerContent> createState() => _AnalizlerContentState();
}

class _AnalizlerContentState extends State<AnalizlerContent> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          NetAnalizler(),
          KonuAnalizler()
        ],
      ),
    );
  }
}