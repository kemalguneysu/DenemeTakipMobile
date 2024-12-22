import 'package:flutter/material.dart';

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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Ayt ID: $aytId", // Parametreyi burada kullanıyoruz
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          const Text(
            "Ana Sayfa İçeriği",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
