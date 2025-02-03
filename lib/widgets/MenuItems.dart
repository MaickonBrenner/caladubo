import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../views/analiseSave.dart';

class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
  });

  final String text;
  final IconData icon;
}

abstract class MenuItems {
  static const List<MenuItem> firstItems = [home, save, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Inicio', icon: Icons.home);
  static const share = MenuItem(text: 'Compartilha', icon: Icons.share);
  static const settings = MenuItem(text: 'Sobre', icon: Icons.info);
  static const save = MenuItem(text: 'Salvos', icon: Icons.save);
  //static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Sair', icon: Icons.logout);


  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        Navigator.push(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
        break;
      case MenuItems.save:
        Navigator.push(
          context as BuildContext,
          MaterialPageRoute(builder: (context) => analiseSaveNew()),
        );
        break;
      case MenuItems.settings: //Configurações

        break;
      case MenuItems.share: // Compartilhar
        
        break;
      case MenuItems.logout:
          SystemNavigator.pop();
        break;
    }
  }
}
//https://pub.dev/packages/dropdown_button2