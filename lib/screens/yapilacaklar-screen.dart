import 'package:mobil_denemetakip/components/yapilacaklar/yapilacaklar.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class YapilacaklarScreen extends StatefulWidget {

  const YapilacaklarScreen({
    super.key,
  });
  @override
  State<YapilacaklarScreen> createState() => _YapilacaklarScreenState();
}

class _YapilacaklarScreenState extends State<YapilacaklarScreen> {
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Yapilacaklar();
    
  }
}
