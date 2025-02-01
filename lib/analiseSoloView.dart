import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _nitrogenio = TextEditingController();
  final TextEditingController _fosforo = TextEditingController();
  final TextEditingController _potassio = TextEditingController();
  final TextEditingController _dataAnalise = TextEditingController();

  Future<void> _selectData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2037),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color.fromRGBO(158, 215, 66, 1),
            )
          ), 
          child: child!
        );
      }
    );
    if (picked != null) {
      setState(() {
        _dataAnalise.text = "${picked.day}/${picked.month}/${picked.year}"; 
      });
    }
  }

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
            'Adicionar Dados',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          backgroundColor: Color.fromRGBO(126, 175, 49, 1),
        ),
        body: SingleChildScrollView( //Padding
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Nessa seção, você poderá inserir e salvar os dados da análise de solo.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15
                  ),
                ),
                const SizedBox(height: 20),
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
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o ph do solo!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nitrogenio,
                  decoration: const InputDecoration(
                    labelText: 'Nitrogênio (N)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter> [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira os valores!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _fosforo,
                  decoration: const InputDecoration(
                    labelText: 'Fósforo (P)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter> [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira os valores!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _potassio,
                  decoration: const InputDecoration(
                    labelText: 'Potássio (K)',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter> [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira os valores!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dataAnalise,
                  decoration: const InputDecoration(
                    labelText: 'Data da Análise',
                  ),
                  readOnly: true,
                  onTap: () => _selectData(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a data da análise!';
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