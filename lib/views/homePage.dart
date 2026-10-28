import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../models/analiseSoloModel.dart';
import 'analisesSalvasPage.dart';
import '../controllers/calculador.dart';

class HomePage extends StatefulWidget {
  final AnaliseSolo? analiseParaEditar;
  const HomePage({super.key, this.analiseParaEditar});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentStep = 0;

  // Controllers para os campos de entrada
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

  final Color verdeCaladubo = const Color.fromRGBO(126, 175, 49, 1);

  @override
  void initState() {
    super.initState();
    // Se estiver editando, preenche os campos com os dados existentes
    if (widget.analiseParaEditar != null) {
      final a = widget.analiseParaEditar!;
      _titulo.text = a.titulo;
      _profundidade.text = a.profundidade.toString();
      _argila.text = a.argila.toString();
      _mo.text = a.mo.toString();
      _ph.text = a.ph.toString();
      _al.text = a.al.toString();
      _h.text = a.h.toString();
      _p.text = a.p.toString();
      _k.text = a.k.toString();
      _ca.text = a.ca.toString();
      _mg.text = a.mg.toString();
      _na.text = a.na.toString();
    }
  }

  @override
  void dispose() {
    _titulo.dispose();
    _profundidade.dispose();
    _ph.dispose();
    _argila.dispose();
    _mo.dispose();
    _p.dispose();
    _k.dispose();
    _ca.dispose();
    _mg.dispose();
    _na.dispose();
    _al.dispose();
    _h.dispose();
    super.dispose();
  }

  // Validação dos campos obrigatórios
  List<String> _validarCampos() {
    List<String> faltando = [];
    if (_titulo.text.trim().isEmpty) faltando.add("Título da Análise");
    if (_ph.text.trim().isEmpty) faltando.add("pH do Solo");
    if (_al.text.trim().isEmpty) faltando.add("Alumínio (Al³⁺)");
    if (_h.text.trim().isEmpty) faltando.add("Hidrogênio (H⁺)");
    if (_k.text.trim().isEmpty) faltando.add("Potássio (K)");
    if (_ca.text.trim().isEmpty) faltando.add("Cálcio (Ca²⁺)");
    if (_mg.text.trim().isEmpty) faltando.add("Magnésio (Mg²⁺)");
    return faltando;
  }

  void _salvarAnalise() async {
    // 1. Preparação dos dados brutos informados pelo usuário
    String dataFinal = widget.analiseParaEditar?.data ??
        DateFormat('dd.MM.yyyy').format(DateTime.now());
    String nomeDigitado = _titulo.text.isEmpty ? "Área Sem Nome" : _titulo.text;

    // Classifica o solo
    Calculador calc = Calculador();
    double getArgila = double.tryParse(_argila.text) ?? 0.0;
    String tipoSolo = calc.classificarSolo(getArgila);

    // 2. Criar/Atualizar o objeto do Modelo de forma limpa (sem cálculos acoplados)
    AnaliseSolo analiseProcessada = AnaliseSolo(
      id: widget.analiseParaEditar?.id, // Se tiver ID, o SQLite entende que é Update
      titulo: nomeDigitado,
      data: dataFinal,
      profundidade: double.tryParse(_profundidade.text) ?? 0.0,
      argila: double.tryParse(_argila.text) ?? 0.0,
      mo: double.tryParse(_mo.text) ?? 0.0,
      ph: double.tryParse(_ph.text) ?? 0.0,
      al: double.tryParse(_al.text) ?? 0.0,
      h: double.tryParse(_h.text) ?? 0.0,
      p: double.tryParse(_p.text) ?? 0.0,
      k: double.tryParse(_k.text) ?? 0.0,
      ca: double.tryParse(_ca.text) ?? 0.0,
      mg: double.tryParse(_mg.text) ?? 0.0,
      na: double.tryParse(_na.text) ?? 0.0,
      detalhes: "Classificação: Solo $tipoSolo\nAnálise cadastrada em $dataFinal.\nAmostra com profundidade de ${_profundidade.text} cm.",
    );

    // 3. Persistência no SQLite (Insert vs Update)
    if (widget.analiseParaEditar == null) {
      await DBHelper().insertAnalise(analiseProcessada);
    } else {
      await DBHelper().updateAnalise(analiseProcessada);
    }

    if (!mounted) return;

    // 4. Feedback visual e redirecionamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: verdeCaladubo),
            const SizedBox(width: 10),
            Text(widget.analiseParaEditar == null ? "Salvo" : "Atualizado"),
          ],
        ),
        content: Text("Dados de '$nomeDigitado' salvos com sucesso!"),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: verdeCaladubo),
            onPressed: () {
              Navigator.pop(context); // Fecha o dialog
              if (widget.analiseParaEditar != null) {
                Navigator.pop(context, true);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AnalisesSalvasPage()),
                );
              }
            },
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _resetForm() {
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
  } 

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.analiseParaEditar != null;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 236, 217, 1),
      appBar: AppBar(
        title: Text(isEditing ? "Editar Análise" : "Nova Análise de Solo"),
        backgroundColor: verdeCaladubo,
        foregroundColor: Colors.white,
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            final faltando = _validarCampos();
            if (faltando.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 10),
                      Text("Campos obrigatórios"),
                    ],
                  ),
                  content: Text(
                      "Preencha os seguintes campos antes de salvar:\n\n${faltando.join('\n')}"),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: verdeCaladubo),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK",
                          style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              );
            } else {
              _salvarAnalise();
              _resetForm();
            }
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
                  child: Text(
                      _currentStep == 3
                          ? (isEditing
                              ? 'Atualizar Dados'
                              : 'Finalizar e Salvar')
                          : 'Próximo',
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
                    decoration: const InputDecoration(
                        labelText: 'Título da Análise (Ex: Talhão 01)')),
                TextFormField(
                    controller: _profundidade,
                    decoration:
                        const InputDecoration(labelText: 'Profundidade em cm (Ex: 20 ou 40)'),
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
                    decoration:
                        const InputDecoration(labelText: 'pH em Água ou CaCl2'),
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
                    decoration: const InputDecoration(
                        labelText: 'Potássio (K) - mg/dm³'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: _ca,
                    decoration: const InputDecoration(
                        labelText: 'Cálcio (Ca²⁺) - cmol/dm³'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: _mg,
                    decoration: const InputDecoration(
                        labelText: 'Magnésio (Mg²⁺) - cmol/dm³'),
                    keyboardType: TextInputType.number),
                TextFormField(
                    controller: _na,
                    decoration: const InputDecoration(labelText: 'Sódio (Na⁺)'),
                    keyboardType: TextInputType.number),
              ],
            ),
            isActive: _currentStep >= 3,
            state: _currentStep == 3 ? StepState.editing : StepState.indexed,
          ),
        ],
      ),
    );
  }
}