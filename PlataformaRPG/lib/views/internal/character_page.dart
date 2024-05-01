import 'package:flutter/material.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import '../../services/service_locator.dart';
import '../shared/drawer_view.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

final IHubConnectionService hubConnect = getIt<IHubConnectionService>();

class _CharacterPageState extends State<CharacterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 51, 56),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
      ),
      body: EstruturaPagina(
        index: 2,
        page: Container(),
      ),
    );
  }
}
