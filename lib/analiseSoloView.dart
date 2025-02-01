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

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tipoSolo = TextEditingController();
  final TextEditingController _phSolo = TextEditingController();

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
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _tipoSolo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Solo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira tipo de solo!';
                    }
                      return null;
                  },
                ),
                TextFormField(
                  controller: _phSolo,
                  decoration: const InputDecoration(
                    labelText: 'Ph do Solo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o ph do solo!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Builder(
                  builder: (BuildContext context) {
                    return Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(126, 175, 49, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Processando dados...')),
                            );
                          }
                        },
                        child: const Text(
                        'Salvar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)
                        ),
                      )
                    ); 
                  },
                ),
              ],
            )
          )
        ),
      ),
    );
  }
}