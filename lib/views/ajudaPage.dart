import 'package:flutter/material.dart';
import 'tutorialConteudo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AjudaPage extends StatefulWidget {
  const AjudaPage({super.key});

  @override
  State<AjudaPage> createState() => _AjudaPageState();
}

class _AjudaPageState extends State<AjudaPage>
    with SingleTickerProviderStateMixin {
  final Color verdeCaladubo = const Color.fromRGBO(126, 175, 49, 1);
  late TabController _tabController;

  Future<void> _resetarTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('tutorial_visto');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tutorial será exibido na próxima abertura do app.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  final List<Map<String, String>> _glossario = [
    {
      "termo": "pH do Solo",
      "definicao":
          "Medida da acidez ou alcalinidade do solo, em escala de 0 a 14. Valores abaixo de 7 indicam solo ácido; a maioria das culturas prefere pH entre 5,5 e 6,5."
    },
    {
      "termo": "CTC (Capacidade de Troca Catiônica)",
      "definicao":
          "Capacidade do solo de reter e disponibilizar nutrientes (cátions) para as plantas. Quanto maior a CTC, maior a fertilidade potencial do solo."
    },
    {
      "termo": "Saturação por Bases (V%)",
      "definicao":
          "Percentual da CTC ocupado por bases (Ca, Mg, K), em vez de acidez (H+Al). Indica o quão fértil o solo está no momento da análise."
    },
    {
      "termo": "Calagem",
      "definicao":
          "Prática de aplicar calcário ao solo para corrigir a acidez e elevar a Saturação por Bases a um nível ideal para a cultura."
    },
    {
      "termo": "Macronutrientes",
      "definicao":
          "Nutrientes exigidos em maior quantidade pelas plantas: Nitrogênio (N), Fósforo (P) e Potássio (K), além de Cálcio (Ca), Magnésio (Mg) e Enxofre (S)."
    },
    {
      "termo": "M.O. (Matéria Orgânica)",
      "definicao":
          "Fração do solo composta por resíduos vegetais e animais em decomposição, que melhora a retenção de água e nutrientes."
    },
  ];

  final List<Map<String, String>> _faq = [
    {
      "pergunta": "O aplicativo funciona sem internet?",
      "resposta":
          "Sim! Todas as análises são salvas localmente no seu dispositivo, sem necessidade de conexão."
    },
    {
      "pergunta": "Como sei se meu solo precisa de calcário?",
      "resposta":
          "Ao finalizar uma análise, o app calcula automaticamente a Saturação por Bases e indica se há necessidade de calagem, junto com a quantidade recomendada em t/ha."
    },
    {
      "pergunta": "Posso editar uma análise depois de salva?",
      "resposta":
          "Sim. Na tela de Análises Salvas, toque no ícone de lápis ao lado da análise desejada para editá-la."
    },
    {
      "pergunta": "Meus dados ficam salvos se eu desinstalar o app?",
      "resposta":
          "Não. Os dados são armazenados localmente no dispositivo, então desinstalar o aplicativo apaga o histórico de análises."
    },
    {
      "pergunta": "Posso usar uma análise salva para mais de uma cultura?",
      "resposta":
          "Sim, a mesma análise pode ser consultada na aba de diagnóstico de diferentes culturas disponíveis no app."
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: verdeCaladubo,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.school), text: "Tutorial"),
              Tab(icon: Icon(Icons.menu_book), text: "Glossário"),
              Tab(icon: Icon(Icons.quiz), text: "FAQ"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTutorial(),
              _buildGlossario(),
              _buildFaq(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTutorial() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            itemCount: passosTutorial.length,
            itemBuilder: (context, index) {
              final passo = passosTutorial[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(passo.icone, color: verdeCaladubo, size: 32),
                  title: Text(passo.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(passo.descricao),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _resetarTutorial,
              icon: Icon(Icons.replay, color: verdeCaladubo),
              label: Text("Ver tutorial na próxima abertura",
                  style: TextStyle(color: verdeCaladubo)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: verdeCaladubo),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlossario() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      itemCount: _glossario.length,
      itemBuilder: (context, index) {
        final item = _glossario[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ExpansionTile(
            leading: Icon(Icons.menu_book, color: verdeCaladubo),
            title: Text(item["termo"]!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(item["definicao"]!),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFaq() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      itemCount: _faq.length,
      itemBuilder: (context, index) {
        final item = _faq[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ExpansionTile(
            leading: Icon(Icons.help_outline, color: verdeCaladubo),
            title: Text(item["pergunta"]!,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(item["resposta"]!),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
