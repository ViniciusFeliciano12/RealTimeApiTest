import 'dart:convert';

import 'package:http/http.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import '../models/user.dart';

class HubConnectionService extends IHubConnectionService {
  @override
  late User usuario;

  static const Map<String, String> _keys = {
    'API_ENDPOINT': String.fromEnvironment('API_ENDPOINT')
  };

  static String _getKey(String key) {
    final value = _keys[key] ?? '';
    if (value.isEmpty) {
      throw Exception('$key is not set in Env');
    }
    return value;
  }

  static String get baseUrl => _getKey('API_ENDPOINT');

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
    Response? response;
    try {
      var url = Uri.parse('${baseUrl}api/user/loginAsync');
      var body = jsonEncode({'username': name, 'password': password});
      var headers = {'Content-Type': 'application/json'};
      response = await http.post(url, body: body, headers: headers);
      if (response.statusCode == 200) {
        usuario = User.fromJson(jsonDecode(response.body));
        return "Logado";
      }
    } catch (ex) {
      ex.toString();
    }

    return response!.body;
  }

  @override
  Future<List<Message>> getMessages() async {
    var url = Uri.parse('${baseUrl}api/user/getMessageHistory');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Message> messages =
          jsonResponse.map((data) => Message.fromJson(data)).toList();
      return messages;
    } else {
      return [];
    }
  }

  void stop() {
    hubConnection.stop();
  }
}
