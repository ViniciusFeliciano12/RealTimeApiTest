import 'package:flutter/material.dart';

import '../services/interfaces/ihub_connection.dart';
import '../services/service_locator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final IHubConnectionService hubConnect = getIt<IHubConnectionService>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController userController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

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
                TextField(
                  obscureText: true,
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                      hintText: 'Confirmar senha',
                      filled: true,
                      fillColor: Colors.white),
                  onSubmitted: (value) {},
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (passwordController.text ==
                          confirmPasswordController.text) {
                        var response = await hubConnect.sendRegister(
                            userController.text, passwordController.text);
                        if (response == "Usuário cadastrado") {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                        _showDialog(response);
                      } else {
                        _showDialog("Senha não confere com a confirmação");
                      }
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
          title: const Text("Registro"),
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
