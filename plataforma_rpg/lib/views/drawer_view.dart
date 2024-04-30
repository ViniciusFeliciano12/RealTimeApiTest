import 'package:flutter/material.dart';

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
              // Flexible(
              //   child: ListTile(
              //     hoverColor: const Color.fromARGB(255, 53, 55, 60),
              //     onTap: () {
              //       if (index != 2) {
              //         Navigator.push(
              //           context,
              //           PageRouteBuilder(
              //             pageBuilder:
              //                 (context, animation, secondaryAnimation) =>
              //                     const LoginPage(),
              //           ),
              //         );
              //       }
              //     },
              //     leading: const Text("Página de teste"),
              //   ),
              // ),
            ],
          ),
        ),
        page
      ],
    );
  }
}
