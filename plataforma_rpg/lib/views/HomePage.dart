import 'package:flutter/material.dart';
import 'package:plataforma_rpg/models/message.dart';

import '../services/hubConnection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List<Message> ListMessages = [];
final hubConnect = HubConnect();

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    hubConnect.start((messages) {
      Message message = Message();
      message.name = messages[0];
      message.message = messages[1];
      setState(() {
        ListMessages.add(message);
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  TextEditingController textController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Digite seu nome aqui',
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: ListMessages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      leading: Text("${ListMessages[index].name}: "),
                      title: Text(ListMessages[index].message));
                },
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              focusNode: _focusNode,
              controller: textController,
              decoration: const InputDecoration(
                  hintText: 'Digite algo e pressione Enter',
                  filled: true,
                  fillColor: Colors.white),
              onSubmitted: (value) {
                if (textController.text.isNotEmpty &&
                    nameController.text.isNotEmpty) {
                  hubConnect.hubConnection.invoke("SendMessage",
                      args: [nameController.text, textController.text]);
                  textController.text = "";
                  _focusNode.requestFocus();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
