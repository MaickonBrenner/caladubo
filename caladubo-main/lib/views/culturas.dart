import 'package:flutter/material.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
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
            icon: const Icon(Icons.arrow_back),
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
        body: Padding(
          padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Selecione a cultura desejada abaixo.',
                  style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15
                  ),
                ),
              ),
              Expanded(
                child: ResponsiveGridList(
                  horizontalGridMargin: 80,
                  verticalGridMargin: 80,
                  minItemWidth: 100,
                  children: [
                    InkWell(
                      onTap: changePage,
                      splashColor: Color.fromRGBO(126, 175, 49, 1),
                      child: Ink.image(
                        fit: BoxFit.cover,
                        width: 200,
                        height: 150,
                        image: const AssetImage(
                          'assets/cards/abacate.png'
                        ),
                      ),
                    ),
                    InkWell(
                    onTap: changePage,
                    splashColor: Color.fromRGBO(126, 175, 49, 1),
                      child: Ink.image(
                        fit: BoxFit.cover,
                        width: 200,
                        height: 150,
                        image: const AssetImage(
                          'assets/cards/em_breve.png'
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ) 
      ),
    );
  }
}