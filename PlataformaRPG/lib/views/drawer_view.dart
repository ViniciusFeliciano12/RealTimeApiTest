import 'package:flutter/material.dart';
import 'package:plataforma_rpg/views/test_page.dart';

import 'character_page.dart';

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
    return Row(
      children: [
        Drawer(
          width: 200,
          shadowColor: Colors.transparent,
          backgroundColor: const Color.fromARGB(255, 43, 45, 49),
          child: Column(
            children: [
              Flexible(
                child: ListTile(
                  hoverColor: const Color.fromARGB(255, 53, 55, 60),
                  onTap: () {
                    if (index != 1) {
                      Navigator.pop(context);
                    }
                  },
                  leading: const Text("Chat page"),
                ),
              ),
              Flexible(
                child: ListTile(
                  hoverColor: const Color.fromARGB(255, 53, 55, 60),
                  onTap: () {
                    print(Navigator.of(context).widget.pages.length.toString());
                    if (index != 2) {
                      if (Navigator.of(context).widget.pages.length == 1) {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const CharacterPage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const CharacterPage(),
                          ),
                        );
                      }
                    }
                  },
                  leading: const Text("Página de personagem"),
                ),
              ),
              Flexible(
                child: ListTile(
                  hoverColor: const Color.fromARGB(255, 53, 55, 60),
                  onTap: () {
                    print(Navigator.of(context).widget.pages.length.toString());
                    if (index != 3) {
                      if (Navigator.of(context).widget.pages.length == 1) {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const TestPage(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const TestPage(),
                          ),
                        );
                      }
                    }
                  },
                  leading: const Text("Página de teste"),
                ),
              ),
            ],
          ),
        ),
        page
      ],
    );
  }
}
