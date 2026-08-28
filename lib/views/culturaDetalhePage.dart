import 'package:flutter/material.dart';
import '../models/analiseSoloModel.dart';
import '../database/db_helper.dart';
import 'homePage.dart';

class CulturaDetalhePage extends StatefulWidget {
  final String nomeCultura;
  final String imagemCultura;

  const CulturaDetalhePage({
    super.key,
    required this.nomeCultura,
    required this.imagemCultura,
  });

  @override
  State<CulturaDetalhePage> createState() => _CulturaDetalhePageState();
}

class _CulturaDetalhePageState extends State<CulturaDetalhePage>
    with SingleTickerProviderStateMixin {
  final Color verdeCaladubo = const Color.fromRGBO(126, 175, 49, 1);
  late TabController _tabController;

  List<AnaliseSolo> _analisesSalvas = [];
  bool _carregandoAnalises = true;
  AnaliseSolo? _analiseSelecionada;

  // Conteúdo por cultura. Adicione novas entradas aqui quando liberar outras culturas.
  final Map<String, Map<String, dynamic>> _dadosCulturas = {
    "Abacate": {
      "resumo":
          "O abacateiro (Persea americana) é uma frutífera tropical/subtropical que leva, em média, de 3 a 5 anos para iniciar a frutificação quando propagado por mudas enxertadas. O plantio deve ser feito em covas de 60x60x60 cm, espaçadas entre 7 e 10 metros, em solos profundos, bem drenados e com boa exposição solar.",
      "recomendacoes": [
        "Irrigação: 2 a 3 vezes por semana nos primeiros 2 anos, reduzindo a frequência conforme o sistema radicular se desenvolve.",
        "Adubação: reforçar Nitrogênio, Fósforo e Potássio conforme a análise de solo, especialmente na fase de formação.",
        "Poda: poda de formação nos primeiros anos para estruturar a copa.",
        "Calagem: corrigir a acidez do solo (pH ideal entre 5,5 e 6,5) antes do plantio.",
      ],
      "phIdeal": {"min": 5.5, "max": 6.5},
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _carregarAnalises();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _carregarAnalises() async {
    final dados = await DBHelper().getAnalises();
    if (!mounted) return;
    setState(() {
      _analisesSalvas = dados;
      _carregandoAnalises = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dados = _dadosCulturas[widget.nomeCultura];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 236, 217, 1),
      appBar: AppBar(
        title: Text(widget.nomeCultura),
        backgroundColor: verdeCaladubo,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.info_outline), text: "Resumo"),
            Tab(icon: Icon(Icons.checklist), text: "Recomendações"),
            Tab(icon: Icon(Icons.analytics_outlined), text: "Análise"),
          ],
        ),
      ),
      body: dados == null
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  "Conteúdo para esta cultura ainda está em desenvolvimento.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildResumo(dados),
                _buildRecomendacoes(dados),
                _buildAnalise(dados),
              ],
            ),
    );
  }

  Widget _buildResumo(Map<String, dynamic> dados) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              widget.imagemCultura,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                height: 180,
                color: Colors.grey[300],
                child: const Icon(Icons.eco, size: 60, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Sobre a cultura",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: verdeCaladubo),
          ),
          const SizedBox(height: 8),
          Text(
            dados["resumo"] as String,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecomendacoes(Map<String, dynamic> dados) {
    final List<String> recomendacoes =
        List<String>.from(dados["recomendacoes"] as List);
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: recomendacoes.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Icon(Icons.check_circle, color: verdeCaladubo),
            title: Text(recomendacoes[index],
                style: const TextStyle(fontSize: 14)),
          ),
        );
      },
    );
  }

  Widget _buildAnalise(Map<String, dynamic> dados) {
    if (_analiseSelecionada != null) {
      return _buildDiagnostico(dados);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: verdeCaladubo),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                _carregarAnalises();
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Nova Análise de Solo",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Ou selecione uma análise salva para usar no plantio:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _carregandoAnalises
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.green))
              : _analisesSalvas.isEmpty
                  ? const Center(child: Text("Nenhuma análise salva ainda."))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _analisesSalvas.length,
                      itemBuilder: (context, index) {
                        final analise = _analisesSalvas[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: Icon(Icons.assignment_turned_in,
                                color: verdeCaladubo),
                            title: Text(analise.titulo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text("Data: ${analise.data}"),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              setState(() {
                                _analiseSelecionada = analise;
                              });
                            },
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildDiagnostico(Map<String, dynamic> dados) {
    final analise = _analiseSelecionada!;
    final double phAtual = analise.ph;

    final Map<String, dynamic> phIdealRaw =
        Map<String, dynamic>.from(dados["phIdeal"] ?? {});
    final double phMin = (phIdealRaw["min"] as num?)?.toDouble() ?? 0.0;
    final double phMax = (phIdealRaw["max"] as num?)?.toDouble() ?? 14.0;
    final bool phOk = phAtual >= phMin && phAtual <= phMax;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Análise vinculada: ${analise.titulo}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _analiseSelecionada = null),
                icon: Icon(Icons.swap_horiz, color: verdeCaladubo),
                label: Text("Trocar", style: TextStyle(color: verdeCaladubo)),
              ),
            ],
          ),
          const Divider(height: 20),
          Text(
            "Diagnóstico para o plantio de ${widget.nomeCultura}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: verdeCaladubo,
                fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: (phOk ? Colors.green : Colors.orange).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(phOk ? Icons.check_circle : Icons.warning_amber,
                    color: phOk ? Colors.green : Colors.orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    phOk
                        ? "pH do solo (${phAtual.toStringAsFixed(1)}) está dentro da faixa ideal para ${widget.nomeCultura} ($phMin a $phMax)."
                        : "pH do solo (${phAtual.toStringAsFixed(1)}) está fora da faixa ideal para ${widget.nomeCultura} ($phMin a $phMax). Recomenda-se correção antes do plantio.",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text("Laudo completo da análise:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10)),
            child: Text(analise.detalhes, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
