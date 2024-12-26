import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  final String baseSignalRUrl;
  final Map<String, HubConnection> hubConnections = {};

  SignalRService(this.baseSignalRUrl);

  Future<HubConnection> start(String hubUrl, {String? userId}) async {
    if (!hubConnections.containsKey(hubUrl)) {
      final fullHubUrl = userId != null
          ? '$baseSignalRUrl$hubUrl?userId=$userId'
          : '$baseSignalRUrl$hubUrl';
      final hubConnection = HubConnectionBuilder()
          .withUrl(fullHubUrl)
          .withAutomaticReconnect()
          .build();

      try {
        await hubConnection.start();
      } catch (error) {
        Future.delayed(
            Duration(seconds: 2), () => start(hubUrl, userId: userId));
      }

      hubConnections[hubUrl] = hubConnection;
    }
    return hubConnections[hubUrl]!;
  }

  Future<void> invoke(String hubUrl, String procedureName, dynamic message,
      {String? userId,
      Function(dynamic)? successCallBack,
      Function(dynamic)? errorCallBack}) async {
    final connection = await start(hubUrl, userId: userId);
    connection.invoke(procedureName, args: [message]).then((result) {
      if (successCallBack != null) {
        successCallBack(result);
      }
    }).catchError((error) {
      if (errorCallBack != null) {
        errorCallBack(error);
      }
    });
  }

  Future<void> on(String hubUrl, String procedureName, MethodInvocationFunc callBack,
      {String? userId}) async {
    final connection = await start(hubUrl, userId: userId);
    connection.on(procedureName, callBack);
  }

  Future<void> off(String hubUrl, String procedureName,
      {String? userId}) async {
    final connection = await start(hubUrl, userId: userId);
    connection.off(procedureName);
  }
}
