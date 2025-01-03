import 'package:flutter/material.dart';
import 'package:mobil_denemetakip/components/denemelerim/ayt/singleAyt/singleAyt.dart';

class AytScreen extends StatefulWidget {
  final String aytId;

  const AytScreen({Key? key, required this.aytId}) : super(key: key);

  @override
  _AytScreenState createState() => _AytScreenState();
}

class _AytScreenState extends State<AytScreen> {
  late String aytId;

  @override
  void initState() {
    super.initState();
    // Parametreyi widget'tan alıyoruz
    aytId = widget.aytId;
  }

  @override
  Widget build(BuildContext context) {
    return SingleAytContent(aytId: aytId,);
  }
}
