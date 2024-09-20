import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'MenuItems.dart';
import 'colors.dart';

class homePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: homePageNew()
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

  void backPage() {
    setState(() {
      Navigator.pop(context);
    });
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
                  Icons.list,
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
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              child: ElevatedButton(
                onPressed: backPage,
                child: Text("Voltar"),

              ),
            ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
          onPressed: backPage,
          tooltip: 'Informações',
          child: const Icon(Icons.info),
      ), 
      ),
    );
  }

}