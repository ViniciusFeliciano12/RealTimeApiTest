import '../../models/character.dart';
import '../../models/message.dart';
import '../../models/user.dart';

abstract class IHubConnectionService {
  User get usuario;
  set usuario(User value);
  void start();
  Stream<List<Message>> get listaStream;
  void sendMessage(String message);
  Future<String> sendRegister(String name, String password);
  Future<String> sendLogin(String name, String password);
  Future<List<Message>> getMessages();
  List<Character> get listCharacters;
  void stop();
  Future<int> createNewCharacter(Character character);
}
