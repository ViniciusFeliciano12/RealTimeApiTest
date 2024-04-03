import 'package:signalr_netcore/signalr_client.dart';

class HubConnect {
  final hubConnection =
      HubConnectionBuilder().withUrl("http://26.159.154.197:5207/chat").build();

  void start(Function(dynamic) onMessageReceived) async {
    hubConnection.on("ReceiveMessage", onMessageReceived);
    await hubConnection.start();
  }

  void stop() {
    hubConnection.stop();
  }
}
