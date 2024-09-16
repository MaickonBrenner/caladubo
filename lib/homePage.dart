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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}