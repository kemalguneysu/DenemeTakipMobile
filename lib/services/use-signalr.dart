import 'package:flutter/material.dart';
import 'package:mobil_denemetakip/services/signalr-service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UseSignalR extends StatefulWidget {
  final Widget child;

  const UseSignalR({Key? key, required this.child}) : super(key: key);

  @override
  _UseSignalRState createState() => _UseSignalRState();

  static SignalRService? of(BuildContext context) {
    final _UseSignalRState? state =
        context.findAncestorStateOfType<_UseSignalRState>();
    return state?.service;
  }
}

class _UseSignalRState extends State<UseSignalR> {
  SignalRService? service;

  @override
  void initState() {
    super.initState();
    final baseSignalRUrl = "https://api.denemetakip.com";
    service = SignalRService(baseSignalRUrl);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
