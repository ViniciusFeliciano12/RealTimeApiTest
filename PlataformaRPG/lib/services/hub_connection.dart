import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:plataforma_rpg/services/service_locator.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/message.dart';
import '../models/user.dart';
import 'interfaces/inavigation_service.dart';

class HubConnectionService extends IHubConnectionService {
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

  List<Message> listMessages = [];

  @override
  List<Character> listCharacters = [];

  final StreamController<List<Message>> _listaController =
      StreamController<List<Message>>.broadcast(sync: true);

  @override
  Stream<List<Message>> get listaStream => _listaController.stream;
  @override
  late User usuario;
  final player = AudioPlayer();
  late HubConnection hubConnection;

  @override
  void start() async {
    listMessages = await getMessages();

    _listaController.add(listMessages);

    hubConnection = HubConnectionBuilder().withUrl("${baseUrl}chat").build();

    hubConnection.on(
      "ReceiveMessage",
      (dynamic messages) {
        Message message = Message(
            message: messages[1],
            messageHour: messages[2],
            name: messages[0],
            nameVisible: true);

        if (listMessages.isNotEmpty && message.name == listMessages.last.name) {
          message.nameVisible = false;
        }
        listMessages.add(message);
        _listaController.add(listMessages);

        if (!getIt<INavigationService>().getVisibility()) {
          player.play(AssetSource('sounds/notification.wav'));
        }
      },
    );

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
    var headers = {'Content-Type': 'application/json'};

    var body = jsonEncode({'username': name, 'password': password});
    var response = await http.post(url, body: body, headers: headers);

    return response.body;
  }

  @override
  Future<String> sendLogin(String name, String password) async {
    Response? response;
    try {
      var url = Uri.parse('${baseUrl}api/user/loginAsync');
      var headers = {'Content-Type': 'application/json'};
      var body = jsonEncode({'username': name, 'password': password});
      response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        usuario = User.fromJson(jsonDecode(response.body));
        await getCharacters();
        start();
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

  Future getCharacters() async {
    listCharacters = [];
    var url = Uri.parse(
        '${baseUrl}character/getAllCharacters?userID=${usuario.userID}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      listCharacters =
          jsonResponse.map((data) => Character.fromJson(data)).toList();
    }
  }

  @override
  Future<int> createNewCharacter(Character character) async {
    var url = Uri.parse('${baseUrl}character/createCharacterAsync');
    var headers = {'Content-Type': 'application/json'};
    character.userID = usuario.userID;
    var body = jsonEncode(character.toJson());
    var response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      await getCharacters();
    }
    return response.statusCode;
  }

  @override
  void stop() {
    hubConnection.stop();
  }
}
