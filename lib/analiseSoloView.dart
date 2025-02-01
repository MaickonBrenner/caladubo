import 'package:flutter/material.dart';

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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(126, 175, 49, 1),
        scaffoldBackgroundColor: Color.fromRGBO(251, 236, 217, 1),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Adicionar Análise de Solo',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}