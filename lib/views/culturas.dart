import 'package:flutter/material.dart';
import 'homePage.dart';

class culturas extends StatelessWidget {
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: culturasNew(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class culturasNew extends StatefulWidget {
  const culturasNew({Key? key}) : super(key: key);
  @override
  culturasState createState() {
    return culturasState();
  }
}

class culturasState extends State<culturasNew> {

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
        colorScheme: ColorScheme.light(
           primary: Color.fromARGB(255, 78, 124, 3),
        )
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: changePage,
          ),
          title: const Text(
            'Culturas',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          backgroundColor: Color.fromRGBO(126, 175, 49, 1),
        ),
        body: const SingleChildScrollView(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  //child: Image(image: image),
                )
              ]
          ),
        ),
      )
    );
  }
}