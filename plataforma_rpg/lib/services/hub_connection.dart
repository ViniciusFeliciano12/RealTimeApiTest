import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';

class HubConnectionService extends IHubConnectionService {
  final hubConnection =
      HubConnectionBuilder().withUrl("http://192.168.0.7:5207/chat").build();

  @override
  void start(Function(dynamic) onMessageReceived) async {
    hubConnection.on("ReceiveMessage", onMessageReceived);
    await hubConnection.start();
  }

  @override
  void sendMessage(String name, String message) async {
    await hubConnection.invoke("SendMessage", args: [name, message]);
  }

  void stop() {
    hubConnection.stop();
  }
}
