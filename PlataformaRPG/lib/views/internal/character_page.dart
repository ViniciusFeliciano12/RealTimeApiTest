import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/character.dart';
import '../../models/character_stats.dart';
import '../../services/interfaces/ihub_connection.dart';
import '../../services/service_locator.dart';

class CharacterPage extends StatefulWidget {
  const CharacterPage({super.key});

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

final IHubConnectionService hubConnect = getIt<IHubConnectionService>();

late List<Character> characters;
final ImagePicker _picker = ImagePicker();

Uint8List? _pickedImage = null;

class _CharacterPageState extends State<CharacterPage> {
  @override
  void initState() {
    super.initState();
    setState(() {
      characters = hubConnect.listCharacters;
    });
  }

  late TextEditingController characterName = TextEditingController();
  late TextEditingController age = TextEditingController();
  late TextEditingController height = TextEditingController();
  late TextEditingController superpower = TextEditingController();
  late String appearance;
  late int points = 5;
  late TextEditingController strength = TextEditingController(text: "1");
  late TextEditingController resistence = TextEditingController(text: "1");
  late TextEditingController agility = TextEditingController(text: "1");
  late TextEditingController inteligence = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      color: const Color.fromARGB(255, 43, 45, 49),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: characters.isEmpty
              ? createNewCharacter()
              : hasCharactersRegistered(),
        ),
      ),
    );
  }

  Column hasCharactersRegistered() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.memory(base64.decode(characters.first.appearanceImage)),
          Text("Nome: ${characters.first.characterName}"),
          Text("Idade: ${characters.first.age}"),
          Text("Altura: ${characters.first.height}"),
          Text("Superpower: ${characters.first.superPower}"),
        ]);
  }

  SingleChildScrollView createNewCharacter() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text("Informações do personagem")),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.transparent,
            height: 200,
            child: _pickedImage == null
                ? IconButton(
                    color: Colors.red,
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      var mediaData =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (mediaData != null) {
                        var teste = await mediaData.readAsBytes();
                        setState(() {
                          _pickedImage = teste;
                        });
                      }
                    })
                : Image.memory(_pickedImage!),
          ),
          TextField(
            controller: characterName,
            onTap: () {},
            decoration: const InputDecoration(
                hintText: "Nome: ",
                hintStyle:
                    TextStyle(color: Color.fromARGB(255, 136, 136, 136))),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: age,
            onTap: () {},
            decoration: const InputDecoration(
                hintText: "Idade: ",
                hintStyle:
                    TextStyle(color: Color.fromARGB(255, 136, 136, 136))),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: height,
            onTap: () {},
            decoration: const InputDecoration(
                hintText: "Altura: ",
                hintStyle:
                    TextStyle(color: Color.fromARGB(255, 136, 136, 136))),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: superpower,
            onTap: () {},
            decoration: const InputDecoration(
                hintText: "Poder: ",
                hintStyle:
                    TextStyle(color: Color.fromARGB(255, 136, 136, 136))),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            color: Colors.grey,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text("Status do personagem")),
            ),
          ),
          const SizedBox(height: 4),
          Text("Pontos a distribuir: $points",
              style:
                  const TextStyle(color: Color.fromARGB(255, 136, 136, 136))),
          TextFormField(
            style: const TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
            controller: strength,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Força: ',
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      int? teste = int.tryParse(strength.text);
                      if (teste != null && points > 0) {
                        teste++;
                        setState(() {
                          points--;
                          strength.text = teste.toString();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_upward, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {
                      int? teste = int.tryParse(strength.text);
                      if (teste != null && points < 5) {
                        teste--;
                        setState(() {
                          points++;
                          strength.text = teste.toString();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_downward, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          TextFormField(
            style: const TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
            controller: resistence,
            readOnly: true,
            decoration: InputDecoration(
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
              labelText: 'Resistencia: ',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      int? teste = int.tryParse(resistence.text);
                      if (teste != null && points > 0) {
                        teste++;
                        setState(() {
                          points--;
                          resistence.text = teste.toString();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_upward, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {
                      int? teste = int.tryParse(resistence.text);
                      if (teste != null && points < 5) {
                        teste--;

                        setState(() {
                          points++;
                          resistence.text = teste.toString();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_downward, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          TextFormField(
            style: const TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
            controller: agility,
            readOnly: true,
            decoration: InputDecoration(
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
              labelText: 'Agilidade: ',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      int? teste = int.tryParse(agility.text);
                      if (teste != null && points > 0) {
                        teste++;
                        setState(() {
                          points--;
                          agility.text = teste.toString();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_upward, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {
                      int? teste = int.tryParse(agility.text);
                      if (teste != null && points < 5) {
                        teste--;

                        setState(() {
                          points++;
                          agility.text = teste.toString();
                        });
                      }
                    },
                    icon: const Icon(Icons.arrow_downward, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          TextFormField(
            controller: inteligence,
            readOnly: true,
            style: const TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
            decoration: InputDecoration(
              labelStyle:
                  const TextStyle(color: Color.fromARGB(255, 136, 136, 136)),
              labelText: 'Inteligencia',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      int? teste = int.tryParse(inteligence.text);
                      if (teste != null && points > 0) {
                        teste++;
                        setState(() {
                          points--;
                          inteligence.text = teste.toString();
                        });
                        inteligence.text = teste.toString();
                      }
                    },
                    icon: const Icon(Icons.arrow_upward, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {
                      int? teste = int.tryParse(inteligence.text);
                      if (teste != null && points < 5) {
                        teste--;
                        setState(() {
                          points++;
                          inteligence.text = teste.toString();
                        });
                        inteligence.text = teste.toString();
                      }
                    },
                    icon: const Icon(Icons.arrow_downward, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            child: const Text("Enviar"),
            onPressed: () async {
              if (characterName.text.isNotEmpty &&
                  age.text.isNotEmpty &&
                  height.text.isNotEmpty &&
                  superpower.text.isNotEmpty &&
                  _pickedImage != null) {
                CharacterStats stats = CharacterStats(
                    characterLevel: 1,
                    experience: 0,
                    points: points,
                    strength: int.tryParse(strength.text)!,
                    resistance: int.tryParse(resistence.text)!,
                    agility: int.tryParse(agility.text)!,
                    inteligence: int.tryParse(inteligence.text)!);
                Character character = Character(
                    characterStats: stats,
                    characterName: characterName.text,
                    age: int.tryParse(age.text)!,
                    height: double.tryParse(height.text)!,
                    superPower: superpower.text,
                    appearanceImage: base64Encode(_pickedImage as List<int>),
                    weaponImage: "weaponImage");
                var response = await hubConnect.createNewCharacter(character);
                if (response == 200) {
                  setState(() {
                    characters = hubConnect.listCharacters;
                  });
                }
              }
            },
          )
        ],
      ),
    );
  }
}
