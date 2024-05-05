import 'package:flutter/material.dart';
import '../../services/interfaces/ihub_connection.dart';
import '../../services/interfaces/inavigation_service.dart';
import '../../services/service_locator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late IHubConnectionService hubConnect = getIt<IHubConnectionService>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future tryRegister() async {
      if (passwordController.text == confirmPasswordController.text &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty) {
        var response = await hubConnect.sendRegister(
            userController.text, passwordController.text);
        if (response == "Usuário cadastrado.") {
          if (!mounted) return;
          Navigator.pop(context);
        }
        _showDialog(response);
      } else {
        _showDialog("Senha não confere com a confirmação.");
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
              fit: BoxFit.cover, // Ajusta a imagem para cobrir todo o container
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
                  mainAxisSize: MainAxisSize.min,
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
                    const SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          hintText: 'Senha',
                          filled: true,
                          fillColor: Colors.white),
                      onSubmitted: (value) {},
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                          hintText: 'Confirmar senha',
                          filled: true,
                          fillColor: Colors.white),
                      onSubmitted: (value) async {
                        await tryRegister();
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      onPressed: () async {
                        await tryRegister();
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
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text("Registro"),
          content: Text(message),
          actions: <Widget>[
            // define os botões na base do dialogo
            ElevatedButton(
              child: const Text("Fechar"),
              onPressed: () {
                getIt<INavigationService>().backToLastPage(context);
              },
            ),
          ],
        );
      },
    );
  }
}
