import 'package:mobil_denemetakip/components/denemelerim/ayt-create.dart';
import 'package:mobil_denemetakip/components/denemelerim/tyt-create.dart';
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
  DateTime? _date;
 
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
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  DatePicker(
                    value: _date,
                    mode: PromptMode.dialog,
                    dialogTitle: const Text('Tarih Seç'),
                    stateBuilder: (date) {
                      return DateState.enabled;
                    },
                    onChanged: (value) {
                      setState(() {
                        _date = value;
                      });
                    },
                  ),
                ],
              ),
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
