import 'package:flutter/material.dart';
import 'culturaDetalhePage.dart';

class CulturasEspecificasPage extends StatelessWidget {
  final String grupoNome;

  const CulturasEspecificasPage({super.key, required this.grupoNome});

  @override
  Widget build(BuildContext context) {
    // 1. Mudamos para <String, dynamic> para aceitar o "disponivel" (que é um booleano true/false)
    final Map<String, List<Map<String, dynamic>>> bancoDeCulturas = {
      "Frutíferas": [
        {
          "nome": "Abacate",
          "imagem": "assets/cards/abacate.png",
          "disponivel": true
        }, // Só o abacate está ativo!
        {
          "nome": "Banana",
          "imagem": "assets/cards/banana.png",
          "disponivel": false
        },
        {
          "nome": "Abacaxi",
          "imagem": "assets/cards/abacaxi.png",
          "disponivel": false
        },
        {
          "nome": "Laranja",
          "imagem": "assets/cards/laranja.png",
          "disponivel": false
        },
      ],
      "Grandes Cul.": [
        {
          "nome": "Soja",
          "imagem": "assets/cards/soja.png",
          "disponivel": false
        },
        {
          "nome": "Milho",
          "imagem": "assets/cards/milho.png",
          "disponivel": false
        },
        {
          "nome": "Algodão",
          "imagem": "assets/cards/algodao.png",
          "disponivel": false
        },
        {
          "nome": "Café",
          "imagem": "assets/cards/cafe.png",
          "disponivel": false
        },
      ],
      "Leguminosas": [
        {
          "nome": "Feijão",
          "imagem": "assets/cards/feijao.png",
          "disponivel": false
        },
        {
          "nome": "Ervilha",
          "imagem": "assets/cards/ervilha.png",
          "disponivel": false
        },
        {
          "nome": "Amendoim",
          "imagem": "assets/cards/amendoim.png",
          "disponivel": false
        },
        {
          "nome": "Lentilha",
          "imagem": "assets/cards/lentilha.png",
          "disponivel": false
        },
      ],
      "Olericultura": [
        {
          "nome": "Alface",
          "imagem": "assets/cards/alface.png",
          "disponivel": false
        },
        {
          "nome": "Tomate",
          "imagem": "assets/cards/tomate.png",
          "disponivel": false
        },
        {
          "nome": "Cenoura",
          "imagem": "assets/cards/cenoura.png",
          "disponivel": false
        },
        {
          "nome": "Cebola",
          "imagem": "assets/cards/cebola.png",
          "disponivel": false
        },
      ],
    };

    final List<Map<String, dynamic>> culturasParaMostrar =
        bancoDeCulturas[grupoNome] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          grupoNome,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(126, 175, 49, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromRGBO(251, 236, 217, 1),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Culturas disponíveis em $grupoNome',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(34, 29, 12, 1),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: culturasParaMostrar.length,
                itemBuilder: (context, index) {
                  final cultura = culturasParaMostrar[index];
                  final bool isDisponivel = cultura["disponivel"];

                  // Monta a imagem base
                  Widget imagemDaCultura = Image.asset(
                    cultura["imagem"]!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/cards/em_breve.png",
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey),
                    ),
                  );

                  // 2. O Filtro Mágico: Remove as cores se não estiver disponível
                  if (!isDisponivel) {
                    imagemDaCultura = ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
                      child: imagemDaCultura,
                    );
                  }

                  return GestureDetector(
                    // 3. Se estiver disponível, libera o clique, senão fica nulo (inativo)
/*                     onTap: isDisponivel
                        ? () {
                            // Aqui você pode colocar a navegação pro formulário depois!
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Iniciando análise para ${cultura["nome"]}...'),
                                backgroundColor:
                                    const Color.fromRGBO(126, 175, 49, 1),
                              ),
                            );
                          }
                        : null, */
                    onTap: isDisponivel
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CulturaDetalhePage(
                                  nomeCultura: cultura["nome"] as String,
                                  imagemCultura: cultura["imagem"] as String,
                                ),
                              ),
                            );
                          }
                        : null,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        // Borda fica cinza se inativo
                        side: BorderSide(
                          color: isDisponivel
                              ? const Color.fromRGBO(126, 175, 49, 1)
                              : Colors.grey.shade400,
                          width: isDisponivel ? 4 : 2,
                        ),
                      ),
                      elevation:
                          isDisponivel ? 3 : 1, // Card inativo fica mais plano
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: imagemDaCultura,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            // Faixa do nome fica cinza se inativo
                            color: isDisponivel
                                ? const Color.fromRGBO(126, 175, 49, 1)
                                : Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              cultura["nome"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDisponivel
                                    ? Colors.white
                                    : Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
