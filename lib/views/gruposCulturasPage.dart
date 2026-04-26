import 'package:flutter/material.dart';
import 'culturasEspecificasPage.dart';

class GruposCulturasPage extends StatelessWidget {
  const GruposCulturasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> grupos = [
      {"nome": "Frutíferas", "icone": Icons.apple},
      {"nome": "Grandes Cul.", "icone": Icons.grass},
      {"nome": "Leguminosas", "icone": Icons.spa},
      {"nome": "Olericultura", "icone": Icons.local_florist},
    ];

    return Container(
      color: const Color.fromRGBO(251, 236, 217, 1),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Escolha um grupo de culturas',
              style: TextStyle(
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
              itemCount: grupos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CulturasEspecificasPage(
                            grupoNome: grupos[index]["nome"]!),
                      ),
                    );
                  },
                  child: Card(
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
                            color: Colors.grey[
                                200], // Fundo levemente cinza para destacar o ícone

                            // AQUI ESTÁ O SEU ÍCONE DE VOLTA!
                            child: Icon(grupos[index]["icone"],
                                size: 70,
                                color: const Color.fromRGBO(
                                    126, 175, 49, 1) // Verde do tema
                                ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          color: const Color.fromRGBO(126, 175, 49, 1),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            grupos[index]["nome"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
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
    );
  }
}
