import 'package:flutter/material.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:plataforma_rpg/services/interfaces/inavigation_service.dart';
import 'package:plataforma_rpg/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'MyApp.dart';

INavigationService navigationService = getIt<INavigationService>();

void main() async {
  setupServiceLocator();
  appListeners();

  runApp(MyApp(logado: await checkUserLoggedIn()));
}

void appListeners() {
  html.window.onFocus.listen((event) {
    navigationService.setVisibility(true);
  });

  html.window.onBlur.listen((event) {
    navigationService.setVisibility(false);
  });
}

Future<bool> checkUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? username = prefs.getString('username');
  String? password = prefs.getString('password');

  if (username != null && password != null) {
    final IHubConnectionService hubConnect = getIt<IHubConnectionService>();
    navigationService.changeIndex(1);
    return await hubConnect.sendLogin(username, password) == "Logado";
  }
  return false;
}
