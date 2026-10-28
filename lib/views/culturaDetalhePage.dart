import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/analiseSoloModel.dart';
import '../models/prescritor.dart';
import '../controllers/interpretador.dart';
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
  bool _carregandoJson = true;
  AnaliseSolo? _analiseSelecionada;

  final Map<String, Prescritor> _dadosCulturas = {};

  int _idadeSelecionadaAno = 0; 
  double _prntInformado = 100.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    await Future.wait([
      _carregarAnalises(),
      _carregarCulturasDosJson(),
    ]);
  }

  Future<void> _carregarCulturasDosJson() async {
    try {
      final manifestMap = await AssetManifest.loadFromAssetBundle(rootBundle);
      final jsonPaths = manifestMap.listAssets().where((String key) =>
          key.startsWith('assets/json/') && key.endsWith('.json'));

      for (String path in jsonPaths) {
        final String conteudoJson = await rootBundle.loadString(path);
        final Map<String, dynamic> mapaJson = json.decode(conteudoJson);

        Prescritor prescritor = Prescritor.fromJson(mapaJson);
        if (prescritor.nome.isNotEmpty) {
          _dadosCulturas[prescritor.nome] = prescritor;
        }
      }
    } catch (e) {
      debugPrint("Erro ao carregar arquivos JSON de culturas: $e");
    } finally {
      if (mounted) {
        setState(() {
          _carregandoJson = false;
        });
      }
    }
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
    final Prescritor? cultura = _dadosCulturas[widget.nomeCultura];

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
      body: _carregandoJson
          ? Center(
              child: CircularProgressIndicator(color: verdeCaladubo),
            )
          : cultura == null
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
                    _buildResumo(cultura),
                    _buildRecomendacoes(cultura),
                    _buildAnalise(cultura),
                  ],
                ),
    );
  }

  Widget _buildResumo(Prescritor cultura) {
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
            cultura.resumo,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecomendacoes(Prescritor cultura) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: cultura.recomendacoes.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: Icon(Icons.check_circle, color: verdeCaladubo),
            title: Text(cultura.recomendacoes[index],
                style: const TextStyle(fontSize: 14)),
          ),
        );
      },
    );
  }

  Widget _buildAnalise(Prescritor cultura) {
    if (_analiseSelecionada != null) {
      return _buildDiagnostico(cultura);
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

  Widget _buildDiagnostico(Prescritor cultura) {
    final analise = _analiseSelecionada!;

    final interpretacao = Interpretador.avaliarEInterpretar(
      analise: analise,
      cultura: cultura,
      idadePlantaAno: _idadeSelecionadaAno,
      prnt: _prntInformado,
    );

    final calc = interpretacao.calculos;

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
            "Laudo Técnico e Recomendações para ${widget.nomeCultura}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: verdeCaladubo,
                fontSize: 16),
          ),
          const SizedBox(height: 12),
          
          // Alerta de pH
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: (interpretacao.pHestaIdeal ? Colors.green : Colors.orange).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(interpretacao.pHestaIdeal ? Icons.check_circle : Icons.warning_amber,
                    color: interpretacao.pHestaIdeal ? Colors.green : Colors.orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(interpretacao.mensagempH),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Card de Calagem Oficial
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Correção do Solo (Calagem)",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(),
                  Text("Tipo recomendado: ${calc.tipoCalcarioRecomendado}"),
                  const SizedBox(height: 6),
                  Text(calc.avisoCalagem, style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Card de Adubação NPK Oficial por Idade
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Adubação NPK Recomendada",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      DropdownButton<int>(
                        value: _idadeSelecionadaAno,
                        items: List.generate(
                          cultura.tabelaAdubacao.length,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text(cultura.tabelaAdubacao[index].epoca),
                          ),
                        ),
                        onChanged: (novoValor) {
                          if (novoValor != null) {
                            setState(() {
                              _idadeSelecionadaAno = novoValor;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                    Text("• Nitrogênio (N): ${calc.adubacaoN} ${calc.unidadeAdubacao}"),
                    Text("• Fósforo (P₂O₅): ${calc.adubacaoP2O5} ${calc.unidadeAdubacao}"),
                    Text("• Potássio (K₂O): ${calc.adubacaoK2O} ${calc.unidadeAdubacao}"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Card de Gessagem / Correção em Profundidade
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Correção do Subsolo (Gessagem)",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const Divider(),
                  Text(interpretacao.avisoGessagem, 
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)), 
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text("Descrição:",
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