import 'package:flutter/material.dart';
import 'package:plataforma_rpg/views/chat_page.dart';
import 'package:plataforma_rpg/views/register_page.dart';
import '../models/message.dart';
import '../services/interfaces/ihub_connection.dart';
import '../services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String? username;
  final String? password;
  const LoginPage({super.key, this.username, this.password});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final IHubConnectionService hubConnect = getIt<IHubConnectionService>();
  List<Message> listMessages = [];

  Future callMessages() async {
    listMessages = await hubConnect.getMessages();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController userController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future onLoginButtonPressed() async {
      var response = await hubConnect.sendLogin(
          userController.text, passwordController.text);

      if (response == "Logado") {
        await callMessages();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', userController.text);
        prefs.setString('password', passwordController.text);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ChatPage(),
          ),
        );
        userController.text = "";
        passwordController.text = "";
      } else {
        _showDialog(response);
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1)),
            width: 200,
            height: 210,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: userController,
                    decoration: const InputDecoration(
                        hintText: 'Usuário',
                        filled: true,
                        fillColor: Colors.white),
                    onSubmitted: (value) {},
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                        hintText: 'Senha',
                        filled: true,
                        fillColor: Colors.white),
                    onSubmitted: (value) async {
                      await onLoginButtonPressed();
                    },
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () async {
                      await onLoginButtonPressed();
                    },
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text("Login"),
          content: Text(message),
          actions: <Widget>[
            // define os botões na base do dialogo
            ElevatedButton(
              child: const Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
