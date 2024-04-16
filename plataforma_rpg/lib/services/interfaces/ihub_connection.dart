import '../../models/user.dart';

abstract class IHubConnectionService {
  User get usuario;
  set usuario(User value);
  void start(Function(dynamic) onMessageReceived);
  void sendMessage(String message);
  void startRegister(Function(dynamic) onMessageReceived);
  void sendRegister(String name, String password);
  void startLogin(Function(dynamic) onMessageReceived);
  void stopLogin();
  void sendLogin(String name, String password);
  void stopRegister();
}
