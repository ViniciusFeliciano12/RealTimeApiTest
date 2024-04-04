abstract class IHubConnectionService {
  void start(Function(dynamic) onMessageReceived);
  void sendMessage(String name, String message);
}
