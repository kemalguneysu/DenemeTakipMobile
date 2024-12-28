import 'package:flutter/material.dart';
import 'package:mobil_denemetakip/components/footer.dart';
import 'package:mobil_denemetakip/components/navigation.dart';
import 'package:mobil_denemetakip/services/theme-service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as sh;

class Layout extends StatelessWidget {
  final Widget child; // Değişen içerik

  const Layout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return sh.Scaffold(
      backgroundColor: sh.Theme.of(context).colorScheme.card,
      headers: [NavigationHeader()],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        child: child,
      ),
      footers: [Footer()],
    );
  }
}
