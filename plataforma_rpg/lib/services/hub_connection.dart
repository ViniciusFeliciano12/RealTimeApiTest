import 'dart:convert';

import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class HubConnectionService extends IHubConnectionService {
  @override
  late User usuario;

  var baseUrl = "http://26.159.154.197:5207/";

  late HubConnection hubConnection;

  @override
  void start(Function(dynamic) onMessageReceived) async {
    hubConnection = HubConnectionBuilder().withUrl("${baseUrl}chat").build();

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
  Future<String> sendRegister(String name, String password) async {
    var url = Uri.parse('${baseUrl}api/user/registerAsync');
    var body = jsonEncode({'username': name, 'password': password});
    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);

    return response.body;
  }

  @override
  Future<String> sendLogin(String name, String password) async {
    var url = Uri.parse('${baseUrl}api/user/loginAsync');
    var body = jsonEncode({'username': name, 'password': password});
    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      usuario = User.fromJson(jsonDecode(response.body));
      return "Logado";
    }
    return response.body;
  }

  void stop() {
    hubConnection.stop();
  }
}
