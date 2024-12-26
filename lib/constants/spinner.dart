import 'package:shadcn_flutter/shadcn_flutter.dart';

class SpinnerWidget extends StatelessWidget {
  const SpinnerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 340),
      child: Center(
        child: CircularProgressIndicator(size: 48),
      ),
    );
  }
}
