import '../models/analiseSoloModel.dart';
import '../models/prescritor.dart';

class ResultadoCalculo {
  final double necessidadeCalagem;
  final String tipoCalcarioRecomendado;
  final double adubacaoN;
  final double adubacaoP2O5;
  final double adubacaoK2O;
  final String unidadeAdubacao;
  final String avisoCalagem;

  ResultadoCalculo({
    required this.necessidadeCalagem,
    required this.tipoCalcarioRecomendado,
    required this.adubacaoN,
    required this.adubacaoP2O5,
    required this.adubacaoK2O,
    required this.unidadeAdubacao,
    required this.avisoCalagem,
  });
}

class Calculador {
  String solo = "Sem dados";

  String classificarSolo(double textura) {
    if (textura <= 150) {
      return solo = "Arenoso";
    } else if (textura <= 350) {
      return solo = "Médio";
    } else if (textura <= 600) {
      return solo = "Argiloso";
    } else {
      return solo = "Muito Argiloso";
    }
  }

  static ResultadoCalculo calcularRecomendacoesOficiais({
    required AnaliseSolo analise,
    required Prescritor cultura,
    required int idadePlantaAno,
    required double prnt,
  }) {
    double caMgMmol = (analise.ca + analise.mg) * 10.0;

    // Fórmula 1: Elevação de Ca + Mg
    double nc1 = 3.0 - (caMgMmol / 10.0) * (100.0 / prnt);
    if (nc1 < 0) nc1 = 0.0;

    // Fórmula 2: Neutralização de Alumínio (Al³⁺)
    double nc2 = 2.0 * (analise.al / 10.0) * (100.0 / prnt);
    if (nc2 < 0) nc2 = 0.0;

    double necessidadeCalagem = 0.0;

    // TRATATIVA DINÂMICA LIDA DIRETAMENTE DO JSON VIA PRESCRITOR!
    if (cultura.metodoCalagem == "SOMATORIO") {
      necessidadeCalagem = nc1 + nc2;
    } else {
      // Padrão "MAIOR_QUANTIDADE"
      necessidadeCalagem = nc1 > nc2 ? nc1 : nc2;
    }

    necessidadeCalagem = double.parse(necessidadeCalagem.toStringAsFixed(2));

    String tipoCalcario = analise.mg < 5.0
        ? "Calcário Dolomítico (Teor de Mg < 5 mmolc/dm³)"
        : "Calcário Calcítico ou Dolomítico";

    String avisoCalagem = necessidadeCalagem > 0
        ? "Aplicar ${necessidadeCalagem.toStringAsFixed(2)} t/ha de calcário a lanço, incorporando a 20 cm."
        : "Solo com boa saturação, sem necessidade de calagem.";

    // NPK por idade/época usando a unidade descrita no JSON
    double n = 0.0;
    double p2o5 = 0.0;
    double k2o = 0.0;

    if (cultura.tabelaAdubacao.isNotEmpty && idadePlantaAno < cultura.tabelaAdubacao.length) {
      final adubacaoAno = cultura.tabelaAdubacao[idadePlantaAno];
      n = adubacaoAno.n;

      int indiceP = 0;
      if (analise.p > 14.2) {
        indiceP = 2;
      } else if (analise.p >= 7.2) {
        indiceP = 1;
      }

      int indiceK = 0;
      if (analise.k > 1.6) {
        indiceK = 2;
      } else if (analise.k >= 0.9) {
        indiceK = 1;
      }

      p2o5 = adubacaoAno.p2o5[indiceP];
      k2o = adubacaoAno.k2o[indiceK];
    }

    return ResultadoCalculo(
      necessidadeCalagem: necessidadeCalagem,
      tipoCalcarioRecomendado: tipoCalcario,
      adubacaoN: n,
      adubacaoP2O5: p2o5,
      adubacaoK2O: k2o,
      unidadeAdubacao: cultura.unidadeAdubacao, // <- Puxado dinamicamente do JSON
      avisoCalagem: avisoCalagem,
    );
  }

  bool calcularNecessidadeDeGesso(double qtdAl, double qtdCa) {
    return qtdAl > 0.5 || qtdCa < 0.5;
  }

  double calcularGessagem(double ncProfundidade) {
    double qg = 0.3 * ncProfundidade;
    return double.parse(qg.toStringAsFixed(2));
  }
}