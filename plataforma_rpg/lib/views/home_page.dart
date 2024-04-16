import 'package:flutter/material.dart';
import 'package:plataforma_rpg/models/message.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../services/service_locator.dart';
import 'drawer_view.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:html' as html;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Message> listMessages = [];
final IHubConnectionService hubConnect = getIt<IHubConnectionService>();
TextEditingController textController = TextEditingController();
final FocusNode _focusNode = FocusNode();
final ScrollController _scrollController = ScrollController();
final player = AudioPlayer();
bool visibility = true;

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    html.window.onFocus.listen((event) {
      setState(() {
        visibility = true;
      });
    });

    html.window.onBlur.listen((event) {
      setState(() {
        visibility = false;
      });
    });

    hubConnect.start((messages) {
      Message message = Message();
      message.name = messages[0];
      message.message = messages[1];
      message.messageHour = messages[2];
      if (listMessages.isNotEmpty && message.name == listMessages.last.name) {
        message.nameVisible = false;
      }
      setState(() {
        listMessages.add(message);
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );

      if (!visibility) {
        player.play(AssetSource('sounds/notification.wav'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 51, 56),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: VisibilityDetector(
        onVisibilityChanged: (info) {
          setState(() {
            visibility = info.visibleFraction * 100 != 0;
          });
        },
        key: Key("key"),
        child: EstruturaPagina(
          index: 1,
          page: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                listaDeMensagens(),
                const SizedBox(height: 20),
                textInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox textInput() {
    return SizedBox(
      height: 45,
      child: TextField(
        focusNode: _focusNode,
        controller: textController,
        decoration: const InputDecoration(
            hintText: 'Digite algo e pressione Enter',
            filled: true,
            fillColor: Colors.white),
        onSubmitted: (value) {
          hubConnect.sendMessage(
              hubConnect.usuario.userName, textController.text);
          textController.text = "";
          _focusNode.requestFocus();
        },
      ),
    );
  }

  Expanded listaDeMensagens() {
    return Expanded(
      child: SelectionArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: listMessages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                onHover: (value) {
                  setState(() {
                    listMessages[index].isHovered = value;
                  });
                },
                hoverColor: const Color.fromARGB(255, 43, 48, 53),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: listMessages[index].nameVisible,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          "${listMessages[index].name} ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 180, 182, 186),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: SizedBox(
                          width: 30,
                          child: Visibility(
                            visible: listMessages[index].isHovered,
                            child: Text("${listMessages[index].messageHour} ",
                                style: const TextStyle(
                                    fontSize: 9,
                                    color: Color.fromARGB(255, 148, 140, 125))),
                          ),
                        )),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            child: Text(
                              listMessages[index].message,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
