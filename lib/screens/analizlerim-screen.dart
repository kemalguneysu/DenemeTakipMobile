import 'package:mobil_denemetakip/components/analizlerim/analizlerContent.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AnalizlerimScreen extends StatefulWidget {
  const AnalizlerimScreen({super.key});

  @override
  State<AnalizlerimScreen> createState() => _AnalizlerimScreenState();
}

class _AnalizlerimScreenState extends State<AnalizlerimScreen> {
  @override
  Widget build(BuildContext context) {
    return AnalizlerContent();
  }
}