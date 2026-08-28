import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/analiseSoloModel.dart';
import 'homePage.dart';

class AnalisesSalvasPage extends StatefulWidget {
  const AnalisesSalvasPage({super.key});

  @override
  State<AnalisesSalvasPage> createState() => _AnalisesSalvasPageState();
}

class _AnalisesSalvasPageState extends State<AnalisesSalvasPage> {
  List<AnaliseSolo> _analises = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  Future<void> _atualizarLista() async {
    setState(() => _carregando = true);
    final dados = await DBHelper().getAnalises();
    setState(() {
      _analises = dados;
      _carregando = false;
    });
  }

  Future<void> _deletarAnalise(int? id) async {
    if (id == null) return;
    await DBHelper().deleteAnalise(id);
    _atualizarLista();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Análise excluída.', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Função centralizada para abrir a edição
  void _irParaEdicao(AnaliseSolo analise) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(analiseParaEditar: analise),
      ),
    ).then((value) {
      // Se a HomePage retornar 'true', significa que algo foi salvo
      _atualizarLista();
    });
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
                    final analise = _analises[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const Icon(Icons.assignment_turned_in,
                            color: Colors.green, size: 30),
                        title: Text(analise.titulo,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("Data: ${analise.data}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: Colors.blue),
                              onPressed: () => _irParaEdicao(analise),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () => _confirmarExclusao(analise),
                            ),
                          ],
                        ),
                        onTap: () => _mostrarDetalhes(context, analise),
                      ),
                    );
                  },
                ),
    );
  }

  void _confirmarExclusao(AnaliseSolo analise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Análise?"),
        content: Text(
            "Tem certeza que deseja apagar permanentemente os dados de '${analise.titulo}'?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text("Cancelar", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deletarAnalise(analise.id);
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void _mostrarDetalhes(BuildContext context, AnaliseSolo analise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(analise.titulo,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        Text("Data: ${analise.data}",
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.pop(context); // Fecha o modal
                      _irParaEdicao(analise); // Abre a edição
                    },
                  ),
                ],
              ),
              const Divider(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSecao("Características Físicas", [
                        "Profundidade: ${analise.profundidade} cm",
                        "Argila: ${analise.argila} %",
                        "M.O.: ${analise.mo}",
                      ]),
                      _buildSecao("Acidez do Solo", [
                        "pH: ${analise.ph}",
                        "Alumínio (Al): ${analise.al}",
                        "Hidrogênio (H): ${analise.h}",
                      ]),
                      _buildSecao("Macronutrientes", [
                        "Fósforo (P): ${analise.p}",
                        "Potássio (K): ${analise.k}",
                        "Cálcio (Ca): ${analise.ca}",
                        "Magnésio (Mg): ${analise.mg}",
                        "Sódio (Na): ${analise.na}",
                      ]),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
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
                            Text(analise.detalhes,
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
          ...linhas.map((linha) => Text(linha,
              style: const TextStyle(fontSize: 15, color: Colors.black87))),
        ],
      ),
    );
  }
}
