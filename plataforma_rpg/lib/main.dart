import 'package:flutter/material.dart';
import 'package:plataforma_rpg/services/service_locator.dart';

import 'MyApp.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}
