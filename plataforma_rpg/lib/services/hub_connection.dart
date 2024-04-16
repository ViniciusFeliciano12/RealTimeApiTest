import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../models/user.dart';

class HubConnectionService extends IHubConnectionService {
  @override
  late User usuario;

  final hubConnection =
      HubConnectionBuilder().withUrl("http://26.159.154.197:5207/chat").build();

  @override
  void start(Function(dynamic) onMessageReceived) async {
    hubConnection.on("ReceiveMessage", onMessageReceived);
    if (hubConnection.state == HubConnectionState.Disconnected) {
      await hubConnection.start();
    }
  }

  @override
  void sendMessage(String message) async {
    await hubConnection.invoke("SendMessage",
        args: [usuario.userID, usuario.userName, message]);
  }

  @override
  void startRegister(Function(dynamic) onMessageReceived) async {
    hubConnection.on("RegisterResponse", onMessageReceived);
    if (hubConnection.state == HubConnectionState.Disconnected) {
      await hubConnection.start();
    }
  }

  @override
  void stopRegister() {
    hubConnection.off("RegisterResponse");
  }

  @override
  void sendRegister(String name, String password) async {
    await hubConnection.invoke("CadastrarUsuario", args: [name, password]);
  }

  @override
  void startLogin(Function(dynamic) onMessageReceived) async {
    hubConnection.on("LoginResponse", onMessageReceived);
    if (hubConnection.state == HubConnectionState.Disconnected) {
      await hubConnection.start();
    }
  }

  @override
  void stopLogin() {
    hubConnection.off("LoginResponse");
  }

  @override
  void sendLogin(String name, String password) async {
    await hubConnection.invoke("Login", args: [name, password]);
  }

  void stop() {
    hubConnection.stop();
  }
}
