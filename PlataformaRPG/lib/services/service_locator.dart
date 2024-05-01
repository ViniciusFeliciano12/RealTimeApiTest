import 'package:get_it/get_it.dart';
import 'package:plataforma_rpg/services/interfaces/ihub_connection.dart';
import 'package:plataforma_rpg/services/interfaces/inavigation_service.dart';

import 'hub_connection.dart';
import 'navigation_service.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  getIt.registerLazySingleton<IHubConnectionService>(
      () => HubConnectionService());
  getIt.registerLazySingleton<INavigationService>(() => NavigationService());
}
