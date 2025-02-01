import 'package:flutter/material.dart';
import 'homePage.dart';

class analiseSoloView extends StatelessWidget {
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: analiseSoloViewNew(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class analiseSoloViewNew extends StatefulWidget {
  const analiseSoloViewNew({Key? key}) : super(key: key);
  @override
  analiseSoloViewState createState() {
    return analiseSoloViewState();
  }
}

class analiseSoloViewState extends State<analiseSoloViewNew> {

  void changePage() {
    setState(() {
      Navigator.push(
        context,
         MaterialPageRoute(builder: (context) => homePage()));
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: changePage,
          ),
          title: const Text(
            'Adicionar Análise de Solo',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          backgroundColor: Color.fromRGBO(126, 175, 49, 1),
        ),
        body: Center(
          
        ),
      ),
    );
  }
}