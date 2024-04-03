import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:plataforma_rpg/services/hubConnection.dart';
import 'MyApp.dart';

void main() {
  final getIt = GetIt.instance;
  getIt.registerSingleton<HubConnect>(HubConnect());

  runApp(const MyApp());
}
