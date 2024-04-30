import 'package:flutter/material.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:plataforma_rpg/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyApp.dart';

void main() async {
  setupServiceLocator();

  runApp(MyApp(logado: await checkUserLoggedIn()));
}

Future<bool> checkUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');
  String? password = prefs.getString('password');

  if (username != null && password != null) {
    final IHubConnectionService hubConnect = getIt<IHubConnectionService>();
    return await hubConnect.sendLogin(username, password) == "Logado";
  }
  return false;
}
