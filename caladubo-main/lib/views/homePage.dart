import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'analisesSalvasPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentStep = 0;

  final _titulo = TextEditingController();
  final _profundidade = TextEditingController();
  final _ph = TextEditingController();
  final _argila = TextEditingController();
  final _mo = TextEditingController();
  final _p = TextEditingController();
  final _k = TextEditingController();
  final _ca = TextEditingController();
  final _mg = TextEditingController();
  final _na = TextEditingController();
  final _al = TextEditingController();
  final _h = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Color verdeCaladubo = const Color.fromRGBO(126, 175, 49, 1);

    return Container(
      color: const Color.fromRGBO(251, 236, 217, 1),
      child: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            _salvarAnalise();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: verdeCaladubo),
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 3 ? 'Finalizar' : 'Próximo',
                      style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Voltar',
                        style: TextStyle(color: Colors.grey)),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('1. Identificação',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              children: [
                TextFormField(
                    controller: _titulo,
                    decoration:
                        const InputDecoration(labelText: 'Título da Análise')),
                TextFormField(
                    controller: _profundidade,
                    decoration:
                        const InputDecoration(labelText: 'Profundidade (cm)'),
                    keyboardType: TextInputType.number),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('2. Físico e Matéria Orgânica',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              children: [
                TextFormField(
                    controller: _argila,
                    decoration: const InputDecoration(labelText: 'Argila (%)'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: _mo,
                    decoration: const InputDecoration(
                        labelText: 'M.O. (Matéria Orgânica)'),
                    keyboardType: TextInputType.number),
              ],
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('3. Acidez',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              children: [
                TextFormField(
                    controller: _ph,
                    decoration: const InputDecoration(labelText: 'pH do Solo'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: _al,
                    decoration: const InputDecoration(
                        labelText: 'Alumínio Tóxico (Al³⁺)'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: _h,
                    decoration:
                        const InputDecoration(labelText: 'Hidrogênio (H⁺)'),
                    keyboardType: TextInputType.number),
              ],
            ),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('4. Macronutrientes e Bases',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: Column(
              children: [
                TextFormField(
                    controller: _p,
                    decoration: const InputDecoration(labelText: 'Fósforo (P)'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: _k,
                    decoration:
                        const InputDecoration(labelText: 'Potássio (K)'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: _ca,
                    decoration:
                        const InputDecoration(labelText: 'Cálcio (Ca²⁺)'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: _mg,
                    decoration:
                        const InputDecoration(labelText: 'Magnésio (Mg²⁺)'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: _na,
                    decoration: const InputDecoration(labelText: 'Sódio (Na⁺)'),
                    keyboardType: TextInputType.number),
              ],
            ),
            isActive: _currentStep >= 3,
          ),
        ],
      ),
    );
  }

  void _salvarAnalise() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historico = prefs.getStringList('banco_analises') ?? [];
    String dataFormatada = DateFormat('dd.MM.yyyy').format(DateTime.now());
    String nomeDigitado = _titulo.text.isEmpty ? "Área Sem Nome" : _titulo.text;

    double k_mg = double.tryParse(_k.text) ?? 0.0;
    double ca = double.tryParse(_ca.text) ?? 0.0;
    double mg = double.tryParse(_mg.text) ?? 0.0;
    double al = double.tryParse(_al.text) ?? 0.0;
    double h = double.tryParse(_h.text) ?? 0.0;

    double k_cmol = k_mg / 391.0;
    double h_al = h + al;
    double sb = ca + mg + k_cmol;
    double ctc = sb + h_al;
    double v_atual = ctc > 0 ? (sb / ctc) * 100 : 0.0;

    double v_desejado = 60.0;
    double prnt = 100.0;
    double necessidadeCalagem = 0.0;
    String avisoSolo = "Solo apresenta boa fertilidade inicial.";

    if (v_atual < v_desejado) {
      necessidadeCalagem = (ctc * (v_desejado - v_atual)) / prnt;
      if (necessidadeCalagem > 0) {
        avisoSolo =
            "ATENÇÃO: Baixa saturação de bases (${v_atual.toStringAsFixed(1)}%).\nRecomendação: Aplicar ${necessidadeCalagem.toStringAsFixed(2)} t/ha de calcário.";
      }
    }

    Map<String, dynamic> novaAnalise = {
      "titulo": "$nomeDigitado - $dataFormatada",
      "detalhes":
          "V%: ${v_atual.toStringAsFixed(1)}% | CTC: ${ctc.toStringAsFixed(2)}\nDiagnóstico: $avisoSolo",
      "prof": _profundidade.text,
      "argila": _argila.text,
      "mo": _mo.text,
      "ph": _ph.text,
      "p": _p.text,
      "k": _k.text,
      "ca": _ca.text,
      "mg": _mg.text,
      "na": _na.text,
      "al": _al.text,
      "h": _h.text,
    };

    historico.add(jsonEncode(novaAnalise));
    await prefs.setStringList('banco_analises', historico);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.science, color: Colors.green),
            SizedBox(width: 10),
            Text("Resultado da Análise"),
          ],
        ),
        content: Text("Dados de '$nomeDigitado' processados!\n\n"
            "Soma de Bases (SB): ${sb.toStringAsFixed(2)}\n"
            "CTC do Solo: ${ctc.toStringAsFixed(2)}\n\n"
            "$avisoSolo"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(126, 175, 49, 1)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnalisesSalvasPage()));
              setState(() {
                _titulo.clear();
                _profundidade.clear();
                _argila.clear();
                _mo.clear();
                _ph.clear();
                _p.clear();
                _k.clear();
                _ca.clear();
                _mg.clear();
                _na.clear();
                _al.clear();
                _h.clear();
                _currentStep = 0;
              });
            },
            child: const Text("Ver no Histórico",
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
