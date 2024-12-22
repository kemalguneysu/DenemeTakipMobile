import 'package:flutter/material.dart';

class TytScreen extends StatefulWidget {
  final String tytId;

  const TytScreen({Key? key, required this.tytId}) : super(key: key);

  @override
  _TytScreenState createState() => _TytScreenState();
}

class _TytScreenState extends State<TytScreen> {
  late String tytId;

  @override
  void initState() {
    super.initState();
    // Parametreyi widget'tan alıyoruz
    tytId = widget.tytId;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Tyt ID: $tytId", // Parametreyi burada kullanıyoruz
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
