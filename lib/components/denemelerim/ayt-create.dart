import 'package:mobil_denemetakip/constants/index.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../services/dersler-service.dart';

class AytCreate extends StatefulWidget {
  final bool isAyt;

  const AytCreate({super.key, required this.isAyt});
  @override
  State<AytCreate> createState() => _AytCreateState();
}

class _AytCreateState extends State<AytCreate> {
   var derslerService = DerslerService();
  List<Ders> dersler = [];
  @override
  void initState() {
    super.initState();
    _fetchDersler();
  }

  Future<void> _fetchDersler() async {
    try {
      final data = await derslerService.getAllDers(isTyt: !widget.isAyt);
      setState(() {
        dersler = data['dersler'];
      });
    } catch (error) {
      print('Failed to load dersler: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: dersler.map((item) {
          return Text(
            item.dersAdi,
            style: TextStyle(fontSize: 55),
          );
        }).toList(),
      ),
    );
  }
}
