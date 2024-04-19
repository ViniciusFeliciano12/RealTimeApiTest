import 'package:flutter/material.dart';
import 'package:plataforma_rpg/views/drawer_view.dart';
import 'package:plataforma_rpg/views/home_page.dart';
import 'package:plataforma_rpg/views/register_page.dart';

import '../models/message.dart';
import '../models/user.dart';
import '../services/interfaces/ihub_connection.dart';
import '../services/service_locator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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

    return Scaffold(
      body: Center(
        child: Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
          width: 200,
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: userController,
                  decoration: const InputDecoration(
                      hintText: 'Usuário',
                      filled: true,
                      fillColor: Colors.white),
                  onSubmitted: (value) {},
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                      hintText: 'Senha', filled: true, fillColor: Colors.white),
                  onSubmitted: (value) {},
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      var response = await hubConnect.sendLogin(
                          userController.text, passwordController.text);

                      if (response == "Logado") {
                        await callMessages();
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    MyHomePage(listMessages: listMessages),
                          ),
                        );
                      } else {
                        _showDialog(response);
                      }
                    },
                    child: const Text("Login"),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ElevatedButton(
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
                ),
              ],
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
