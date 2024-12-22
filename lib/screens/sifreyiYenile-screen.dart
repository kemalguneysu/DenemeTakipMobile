import 'package:flutter/material.dart';

class SifreyiYenileScreen extends StatefulWidget {
  final String userId;
  final String resetToken;

  // Constructor parametrelerini alacak şekilde güncelliyoruz.
  const SifreyiYenileScreen({
    Key? key,
    required this.userId,
    required this.resetToken,
  }) : super(key: key);

  @override
  _SifreyiYenileScreenState createState() => _SifreyiYenileScreenState();
}

class _SifreyiYenileScreenState extends State<SifreyiYenileScreen> {
  late String userId;
  late String resetToken;

  @override
  void initState() {
    super.initState();
    // Parametreleri widget'tan alıp, state'e atıyoruz.
    userId = widget.userId;
    resetToken = widget.resetToken;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "User ID: $userId", // Parametreyi burada kullanıyoruz.
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            "Reset Token: $resetToken", // Parametreyi burada kullanıyoruz.
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
