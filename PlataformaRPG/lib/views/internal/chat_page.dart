import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plataforma_rpg/models/message.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/interfaces/inavigation_service.dart';
import '../../services/service_locator.dart';
import '../external/login_page.dart';
import '../shared/drawer_view.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

final IHubConnectionService hubConnect = getIt<IHubConnectionService>();

TextEditingController textController = TextEditingController();
final ScrollController _scrollController = ScrollController();
final FocusNode _focusNode = FocusNode();
bool firstTime = true;
List<Message> listMessages = [];

late StreamSubscription<List<Message>> onListSubscription;

class _ChatPageState extends State<ChatPage> {
  @override
  void dispose() {
    super.dispose();
    onListSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    });

    onListSubscription = hubConnect.listaStream.listen((event) {
      if (!mounted) return;
      setState(() {
        listMessages = event;
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 51, 56),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        actions: [
          TextButton(
            onPressed: () async {
              (await SharedPreferences.getInstance()).clear();
              if (!mounted) return;
              getIt<INavigationService>()
                  .navigateAndReplace(context, const LoginPage(), 0);
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: EstruturaPagina(
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
            itemCount: listMessages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {},
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
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
                        child: Row(
                          children: [
                            Text(
                              listMessages[index].name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 180, 182, 186),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                listMessages[index].messageHour,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 136, 136, 136),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: SizedBox(
                          width: 30,
                          child: Visibility(
                            visible: listMessages[index].isHovered &&
                                !listMessages[index].nameVisible,
                            child: Text(
                                "${listMessages[index].messageHour.substring(listMessages[index].messageHour.length - 5)} ",
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
