import 'package:flutter/material.dart';
import 'package:plataforma_rpg/views/external/login_page.dart';
import 'package:plataforma_rpg/views/internal/chat_page.dart';

class MyApp extends StatelessWidget {
  final bool logado;
  const MyApp({super.key, required this.logado});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: logado ? const ChatPage() : const LoginPage(),
    );
  }
}
