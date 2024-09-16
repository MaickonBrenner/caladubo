import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: Color.fromRGBO(251, 236, 217, 1)
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Caladubo"),
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
      ),
    );
  }

}