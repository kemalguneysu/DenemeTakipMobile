import 'package:mobil_denemetakip/components/denemelerim/tyt/singleTyt/singleTyt.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class TytScreen extends StatefulWidget {
  final String tytId;
  const TytScreen({Key? key, required this.tytId}) : super(key: key);

  @override
  State<TytScreen> createState() => _TytScreenState();
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
    return SingleTytContent(tytId: tytId,);
  }
}
