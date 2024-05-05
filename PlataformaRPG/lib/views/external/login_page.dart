import 'package:flutter/material.dart';
import 'package:plataforma_rpg/services/interfaces/inavigation_service.dart';
import 'package:plataforma_rpg/views/external/register_page.dart';
import '../../services/interfaces/ihub_connection.dart';
import '../../services/service_locator.dart';
import '../internal/chat_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String? username;
  final String? password;
  const LoginPage({super.key, this.username, this.password});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController userController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future onLoginButtonPressed() async {
      if (userController.text.isEmpty || passwordController.text.isEmpty) {
        return;
      }

      var response = await getIt<IHubConnectionService>()
          .sendLogin(userController.text, passwordController.text);

      if (response == "Logado") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', userController.text);
        prefs.setString('password', passwordController.text);

        if (!mounted) return;
        getIt<INavigationService>()
            .navigateAndReplace(context, const ChatPage(), 1);
      } else {
        _showDialog(response);
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.transparent,
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
                border: Border.all(color: Colors.black, width: 1),
              ),
              width: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: userController,
                      decoration: const InputDecoration(
                          hintText: 'Usuário',
                          filled: true,
                          fillColor: Colors.white),
                      onSubmitted: (value) async {
                        await onLoginButtonPressed();
                      },
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () {
                        getIt<INavigationService>().navigateWithoutReplace(
                            context, const RegisterPage());
                      },
                      child: const Text("Register"),
                    ),
                  ],
                ),
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
        return AlertDialog(
          title: const Text("Login"),
          content: Text(message),
          actions: <Widget>[
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
