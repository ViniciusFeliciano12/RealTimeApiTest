import '../../models/user.dart';

abstract class IHubConnectionService {
  User get usuario;
  set usuario(User value);
  void start(Function(dynamic) onMessageReceived);
  void sendMessage(String message);
  Future<String> sendRegister(String name, String password);
  Future<String> sendLogin(String name, String password);
}
