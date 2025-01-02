import 'package:mobil_denemetakip/components/denemelerim/ayt/ayt-create.dart';
import 'package:mobil_denemetakip/components/denemelerim/tyt/tyt-create.dart';
import 'package:mobil_denemetakip/services/dersler-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../constants/index.dart';

class DenemelerimScreen extends StatefulWidget {
  const DenemelerimScreen({Key? key}) : super(key: key);

  @override
  _DenemelerimScreenState createState() => _DenemelerimScreenState();
}

class _DenemelerimScreenState extends State<DenemelerimScreen> {
  bool isAyt = false;
 
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  leading: const Text("TYT",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),),
                  value: isAyt,
                  onChanged: (value) {
                    setState(() {
                      this.isAyt = value;
                    });
                  },
                  trailing: const Text(
                    "AYT",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Container(
              child: isAyt?AytCreate(isAyt: isAyt):TytCreate(isAyt: isAyt),
            )
          ],
        ),
      ),
    );
  }
}
