import 'package:flutter/material.dart';

class TutorialStep {
  final IconData icone;
  final String titulo;
  final String descricao;

  const TutorialStep({
    required this.icone,
    required this.titulo,
    required this.descricao,
  });
}

const List<TutorialStep> passosTutorial = [
  TutorialStep(
    icone: Icons.eco,
    titulo: "Bem-vindo ao Caladubo",
    descricao:
        "O Caladubo ajuda você a analisar o solo da sua propriedade e receber recomendações de correção e adubação, tudo offline.",
  ),
  TutorialStep(
    icone: Icons.grass,
    titulo: "1. Escolha a cultura",
    descricao:
        "Na aba Culturas, selecione o grupo e depois a cultura desejada para ver informações específicas de plantio.",
  ),
  TutorialStep(
    icone: Icons.edit_note,
    titulo: "2. Preencha a análise",
    descricao:
        "Na aba Análise, insira os dados do laudo de solo (pH, macronutrientes, acidez) em um formulário guiado por etapas.",
  ),
  TutorialStep(
    icone: Icons.science,
    titulo: "3. Veja o diagnóstico",
    descricao:
        "O app calcula automaticamente a CTC, a Saturação por Bases e a necessidade de calagem, indicando a recomendação para o seu solo.",
  ),
  TutorialStep(
    icone: Icons.folder_shared,
    titulo: "4. Consulte o histórico",
    descricao:
        "Todas as análises ficam salvas offline em 'Análises Salvas', podendo ser editadas, excluídas ou vinculadas ao plantio de uma cultura.",
  ),
];
