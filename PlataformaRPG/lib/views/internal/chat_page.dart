import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
bool optionsVisible = false;
bool characterVisible = false;

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
        _scrollController.position.minScrollExtent,
      );
    });

    onListSubscription = hubConnect.listaStream.listen((event) {
      if (!mounted) return;
      setState(() {
        listMessages = event.reversed.toList();
      });
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 100),
      );
    });
  }

  void logout() async {
    (await SharedPreferences.getInstance()).clear();
    hubConnect.stop();
    if (!mounted) return;
    getIt<INavigationService>()
        .navigateAndReplace(context, const LoginPage(), 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 49, 51, 56),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                optionsVisible = false;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                header(),
                body(),
              ],
            ),
          ),
          optionsCard(),
        ],
      ),
    );
  }

  Visibility optionsCard() {
    return Visibility(
      visible: optionsVisible,
      child: Positioned(
        top: 30,
        right: 10,
        child: SizedBox(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            style: const ButtonStyle(
                              shadowColor: MaterialStatePropertyAll(
                                Color.fromARGB(0, 0, 0, 0),
                              ),
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(0, 0, 0, 0),
                              ),
                            ),
                            onPressed: () {
                              optionsVisible = !optionsVisible;
                            },
                            child: const Text("Gerenciar perfil"),
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            style: const ButtonStyle(
                              shadowColor: MaterialStatePropertyAll(
                                Color.fromARGB(0, 0, 0, 0),
                              ),
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(0, 0, 0, 0),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                characterVisible = !characterVisible;
                                optionsVisible = !optionsVisible;
                              });
                            },
                            child: const Text("Mostrar personagem",
                                textAlign: TextAlign.center),
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            style: const ButtonStyle(
                              shadowColor: MaterialStatePropertyAll(
                                Color.fromARGB(0, 0, 0, 0),
                              ),
                              backgroundColor: MaterialStatePropertyAll(
                                Color.fromARGB(0, 0, 0, 0),
                              ),
                            ),
                            onPressed: () async {
                              logout();
                              optionsVisible = !optionsVisible;
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                "assets/images/caret-up-solid.svg",
                width: 20,
                height: 20,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Flexible body() {
    return Flexible(
      child: EstruturaPagina(
        visibility: characterVisible,
        index: 1,
        page: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              listaDeMensagens(),
              const SizedBox(height: 2),
              textInput(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox header() {
    return SizedBox(
      height: 50,
      child: Container(
        color: Colors.blueGrey,
        child: Row(
          children: [
            SizedBox.fromSize(
              size: Size.fromWidth(MediaQuery.of(context).size.width - 160),
            ),
            SizedBox(
              width: 150,
              child: Center(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    shadowColor: MaterialStatePropertyAll(
                      Color.fromARGB(0, 0, 0, 0),
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(0, 0, 0, 0),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      optionsVisible = !optionsVisible;
                    });
                  },
                  child: Text(
                    hubConnect.usuario.userName,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Stack textInput() {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          maxLines: 1,
          focusNode: _focusNode,
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 136, 136, 136),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              focusColor: Colors.transparent,
              hintText: 'Digite algo e pressione enter',
              filled: true,
              fillColor: Color.fromARGB(255, 63, 63, 66)),
          onSubmitted: (value) {
            if (textController.text.isNotEmpty) {
              hubConnect.sendMessage(textController.text);
              textController.text = "";
              _focusNode.requestFocus();
            }
          },
        ),
      ),
      Positioned(
        top: 15,
        right: 15,
        child: IconButton(
          icon: const Icon(
            Icons.send_sharp,
            color: Colors.grey,
          ),
          onPressed: () {
            if (textController.text.isNotEmpty) {
              hubConnect.sendMessage(textController.text);
              textController.text = "";
              _focusNode.requestFocus();
            }
          },
        ),
      ),
    ]);
  }

  Flexible listaDeMensagens() {
    return Flexible(
      child: SelectionArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: ListView.builder(
              reverse: true,
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: listMessages.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      optionsVisible = false;
                    });
                  },
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
                                      color:
                                          Color.fromARGB(255, 148, 140, 125))),
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
      ),
    );
  }
}
