import 'package:flutter/material.dart';
import 'package:plataforma_rpg/models/message.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../services/service_locator.dart';
import 'drawer_view.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:html' as html;

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.listMessages});

  List<Message> listMessages = [];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final IHubConnectionService hubConnect = getIt<IHubConnectionService>();
TextEditingController textController = TextEditingController();
final FocusNode _focusNode = FocusNode();
final ScrollController _scrollController = ScrollController();
final player = AudioPlayer();
bool visibility = true;
bool firstTime = true;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent + 60,
      );
    });

    hubConnect.start((messages) {
      Message message = Message(
          message: messages[1],
          messageHour: messages[2],
          name: messages[0],
          nameVisible: true);

      if (widget.listMessages.isNotEmpty &&
          message.name == widget.listMessages.last.name) {
        message.nameVisible = false;
      }
      setState(() {
        widget.listMessages.add(message);
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
          hubConnect.sendMessage(textController.text);
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
            itemCount: widget.listMessages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onHover: (value) {
                  setState(() {
                    widget.listMessages[index].isHovered = value;
                  });
                },
                hoverColor: const Color.fromARGB(255, 43, 48, 53),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: widget.listMessages[index].nameVisible,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, left: 10),
                        child: Text(
                          "${widget.listMessages[index].name} ",
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
                            visible: widget.listMessages[index].isHovered,
                            child: Text(
                                "${widget.listMessages[index].messageHour} ",
                                style: const TextStyle(
                                    fontSize: 9,
                                    color: Color.fromARGB(255, 148, 140, 125))),
                          ),
                        )),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2, bottom: 2),
                            child: Text(
                              widget.listMessages[index].message,
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
