import 'package:flutter/material.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import '../../services/service_locator.dart';
import '../shared/drawer_view.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

final IHubConnectionService hubConnect = getIt<IHubConnectionService>();

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 51, 56),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: const EstruturaPagina(
        index: 3,
        page: Text("Teste"),
        visibility: false,
      ),
    );
  }
}
