import 'package:shadcn_flutter/shadcn_flutter.dart';

class DenemelerimScreen extends StatefulWidget {
  const DenemelerimScreen({Key? key}) : super(key: key);

  @override
  _DenemelerimScreenState createState() => _DenemelerimScreenState();
}

class _DenemelerimScreenState extends State<DenemelerimScreen> {
  bool isTyt = true;
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Column'ı kaydırılabilir yapmak için
      child: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(
                  value: isTyt,
                  onChanged: (value) {
                    setState(() {
                      this.isTyt = value;
                    });
                  },
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
          ],
        ),
      ),
    );
  }
}
