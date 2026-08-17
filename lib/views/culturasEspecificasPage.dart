import 'package:flutter/material.dart';

class CulturasEspecificasPage extends StatelessWidget {
  final String grupoNome;

  const CulturasEspecificasPage({super.key, required this.grupoNome});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> bancoDeCulturas = {
      "Frutíferas": [
        {"nome": "Abacate", "imagem": "assets/cards/abacate.png"},
        {"nome": "Banana", "imagem": "assets/cards/banana.png"},
        {"nome": "Abacaxi", "imagem": "assets/cards/abacaxi.png"},
        {"nome": "Laranja", "imagem": "assets/cards/laranja.png"},
      ],
      "Grandes Cul.": [
        {"nome": "Soja", "imagem": "assets/cards/soja.png"},
        {"nome": "Milho", "imagem": "assets/cards/milho.png"},
        {"nome": "Algodão", "imagem": "assets/cards/algodao.png"},
        {"nome": "Café", "imagem": "assets/cards/cafe.png"},
      ],
      "Leguminosas": [
        {"nome": "Feijão", "imagem": "assets/cards/feijao.png"},
        {"nome": "Ervilha", "imagem": "assets/cards/ervilha.png"},
        {"nome": "Amendoim", "imagem": "assets/cards/amendoim.png"},
        {"nome": "Lentilha", "imagem": "assets/cards/lentilha.png"},
      ],
      "Olericultura": [
        {"nome": "Alface", "imagem": "assets/cards/alface.png"},
        {"nome": "Tomate", "imagem": "assets/cards/tomate.png"},
        {"nome": "Cenoura", "imagem": "assets/cards/cenoura.png"},
        {"nome": "Cebola", "imagem": "assets/cards/cebola.png"},
      ],
    };

    final List<Map<String, String>> culturasParaMostrar =
        bancoDeCulturas[grupoNome] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(grupoNome,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0)),
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
                    color: Color.fromRGBO(34, 29, 12, 1)),
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
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                          color: Color.fromRGBO(126, 175, 49, 1), width: 4),
                    ),
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: Image.asset(
                              culturasParaMostrar[index]["imagem"]!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                "assets/cards/em_breve.png",
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: const Color.fromRGBO(126, 175, 49, 1),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            culturasParaMostrar[index]["nome"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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
