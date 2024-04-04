import 'package:flutter/material.dart';
import 'package:plataforma_rpg/views/drawer_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: EstruturaPagina(index: 2, page: Text("testando login")),
    );
  }
}
