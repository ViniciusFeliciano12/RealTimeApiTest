import 'package:flutter/material.dart';
import '../../services/interfaces/inavigation_service.dart';
import '../../services/service_locator.dart';
import '../internal/character_page.dart';
import '../internal/chat_page.dart';
import '../internal/test_page.dart';

class EstruturaPagina extends StatelessWidget {
  const EstruturaPagina({
    super.key,
    required this.index,
    required this.page,
  });

  final int index;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    var navigationService = getIt<INavigationService>();
    return Row(
      children: [
        Drawer(
          width: 200,
          shadowColor: Colors.transparent,
          backgroundColor: const Color.fromARGB(255, 43, 45, 49),
          child: Column(
            children: [
              itemListTile(
                  navigationService, context, const ChatPage(), 1, "Chat Page"),
              itemListTile(navigationService, context, const CharacterPage(), 2,
                  "Página de personagem"),
              itemListTile(navigationService, context, const TestPage(), 3,
                  "Página de teste"),
            ],
          ),
        ),
        page
      ],
    );
  }

  SizedBox itemListTile(INavigationService navigationService,
      BuildContext context, Widget page, int index, String name) {
    return SizedBox(
      height: 30,
      width: 200,
      child: ListTile(
        hoverColor: const Color.fromARGB(255, 53, 55, 60),
        onTap: () {
          navigationService.navigateAndReplace(context, page, index);
        },
        leading: Padding(
            padding: const EdgeInsets.only(bottom: 15), child: Text(name)),
      ),
    );
  }
}
