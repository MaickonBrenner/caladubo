import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'MenuItems.dart';
import 'main.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'analiseSoloView.dart';

class homePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: homePageNew(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class homePageNew extends StatefulWidget {
  const homePageNew({Key? key}) : super(key: key);
  @override
  homePageState createState() {
    return homePageState();
  }
}

class homePageState extends State<homePageNew> {
  int _index = 0;

  void _navigateToScreen(int index) {
    setState(() {
      _index = index;
    });

    switch(index) {
      case 0:
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => MyApp())
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => analiseSoloViewNew())
        );
        break;
        
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(126, 175, 49, 1),
        scaffoldBackgroundColor: Color.fromRGBO(251, 236, 217, 1),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Caladubo',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 22,
              ),
            ),
            backgroundColor: Color.fromRGBO(126, 175, 49, 1),
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: const Icon(
                    Icons.list_rounded,
                    size: 46,
                    color: Colors.white,
                  ),
                  items: [
                    ...MenuItems.firstItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                        value: item,
                        child: MenuItems.buildItem(item)
                      ),
                    ),
                    const DropdownMenuItem<Divider>(
                      enabled: false, child: Divider()),
                      ...MenuItems.secondItems.map(
                      (item) => DropdownMenuItem<MenuItem>(
                        value: item,
                        child: MenuItems.buildItem(item),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    MenuItems.onChanged(context, value! as MenuItem);
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 160,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color.fromRGBO(126, 175, 49, 1)
                    ),
                    offset: const Offset(0, 8),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    customHeights: [
                      ...List<double>.filled(MenuItems.firstItems.length, 48),
                      8,
                      ...List<double>.filled(MenuItems.secondItems.length, 48),
                    ],
                    padding: const EdgeInsets.only(left: 16, right: 16),
                  ),
                )
              )
            ],
          ),
          extendBody: true,
          body: const Center(
            // child: ElevatedButton(
            //   onPressed: backPage,
            //   child: Text("Voltar"),
            // ),
          ),
          bottomNavigationBar: FloatingNavbar(
            onTap: _navigateToScreen,
            currentIndex: _index,
            items: [
              FloatingNavbarItem(icon: Icons.home, title: "Início"),
              FloatingNavbarItem(icon: Icons.task_rounded, title: "Análise"),
              FloatingNavbarItem(icon: Icons.help_center, title: "Ajuda")
            ],
            backgroundColor: const Color.fromRGBO(158, 215, 66, 1),
            selectedBackgroundColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
      ),
    );
  }
}