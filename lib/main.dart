import 'package:flutter/material.dart';

import 'homePage.dart';
import 'colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caladubo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(126, 175, 49, 1),
        scaffoldBackgroundColor: Color.fromRGBO(251, 236, 217, 1)
      ),
      home: const MyHomePage(title: 'Caladubo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void changePage() {
    setState(() {
      Navigator.push(
        context,
         MaterialPageRoute(builder: (context) => homePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),*/  
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bem vindo(a) ao',
              style: TextStyle(
                color: Color.fromRGBO(34, 29, 12, 1),
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                fontSize: 22,
              ),
            ),
            Image.asset(
              "images/logo.png",
              width: 250,
              height: 250,
            ),
            ElevatedButton(
              onPressed: changePage, 
              child: Text("Iniciar"))
          ],
        ),
      ),
    );
  }
}