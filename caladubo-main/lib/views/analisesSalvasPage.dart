import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AnalisesSalvasPage extends StatefulWidget {
  const AnalisesSalvasPage({super.key});

  @override
  State<AnalisesSalvasPage> createState() => _AnalisesSalvasPageState();
}

class _AnalisesSalvasPageState extends State<AnalisesSalvasPage> {
  List<Map<String, dynamic>> _analises = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _lerBancoDeDados();
  }

  Future<void> _lerBancoDeDados() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historicoTextos = prefs.getStringList('banco_analises') ?? [];

    setState(() {
      _analises = historicoTextos
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
      _analises = _analises.reversed.toList();
      _carregando = false;
    });
  }

  Future<void> _deletarAnalise(int index) async {
    setState(() {
      _analises.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    List<String> listaAtualizada =
        _analises.reversed.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('banco_analises', listaAtualizada);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('Análise excluída.', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ANÁLISES SALVAS',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(126, 175, 49, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _analises.isEmpty
              ? const Center(
                  child: Text("Nenhuma análise salva no momento.",
                      style: TextStyle(fontSize: 16)))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _analises.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const Icon(Icons.assignment_turned_in,
                            color: Colors.green, size: 30),
                        title: Text(_analises[index]['titulo'] ?? 'Sem Título',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Excluir Análise?"),
                                      content: const Text(
                                          "Tem certeza que deseja apagar permanentemente estes dados?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Cancelar",
                                                style: TextStyle(
                                                    color: Colors.grey))),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deletarAnalise(index);
                                          },
                                          child: const Text("Excluir",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )
                                      ],
                                    ));
                          },
                        ),
                        onTap: () {
                          _mostrarDetalhes(context, _analises[index]);
                        },
                      ),
                    );
                  },
                ),
    );
  }

  void _mostrarDetalhes(BuildContext context, Map<String, dynamic> analise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.75,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(analise['titulo'] ?? 'Análise',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
              const Divider(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSecao("Características Físicas", [
                        "Profundidade: ${analise['prof']?.isEmpty ?? true ? '-' : analise['prof']} cm",
                        "Argila: ${analise['argila']?.isEmpty ?? true ? '-' : analise['argila']} %",
                        "Matéria Orgânica: ${analise['mo']?.isEmpty ?? true ? '-' : analise['mo']}",
                      ]),
                      _buildSecao("Acidez do Solo", [
                        "pH: ${analise['ph']?.isEmpty ?? true ? '-' : analise['ph']}",
                        "Alumínio (Al): ${analise['al']?.isEmpty ?? true ? '-' : analise['al']}",
                        "Hidrogênio (H): ${analise['h']?.isEmpty ?? true ? '-' : analise['h']}",
                      ]),
                      _buildSecao("Macronutrientes", [
                        "Fósforo (P): ${analise['p']?.isEmpty ?? true ? '-' : analise['p']}",
                        "Potássio (K): ${analise['k']?.isEmpty ?? true ? '-' : analise['k']}",
                        "Cálcio (Ca): ${analise['ca']?.isEmpty ?? true ? '-' : analise['ca']}",
                        "Magnésio (Mg): ${analise['mg']?.isEmpty ?? true ? '-' : analise['mg']}",
                        "Sódio (Na): ${analise['na']?.isEmpty ?? true ? '-' : analise['na']}",
                      ]),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Laudo / Recomendação:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                            const SizedBox(height: 5),
                            Text(analise['detalhes'] ?? 'Sem detalhes',
                                style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(126, 175, 49, 1)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Fechar",
                      style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecao(String titulo, List<String> linhas) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          ...linhas
              .map((linha) => Text(linha,
                  style: const TextStyle(fontSize: 15, color: Colors.black87)))
              .toList(),
        ],
      ),
    );
  }
}
