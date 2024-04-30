import 'package:get_it/get_it.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';

import 'hub_connection.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<IHubConnectionService>(
      () => HubConnectionService());
}
