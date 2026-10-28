import '../models/analiseSoloModel.dart';
import '../models/prescritor.dart';
import 'calculador.dart';

class InterpretadorResult {
  final bool pHestaIdeal;
  final String mensagempH;
  final ResultadoCalculo calculos;
  final String avisoGessagem;

  InterpretadorResult({
    required this.pHestaIdeal,
    required this.mensagempH,
    required this.calculos,
    required this.avisoGessagem,
  });
}

class Interpretador {
  static InterpretadorResult avaliarEInterpretar({
    required AnaliseSolo analise,
    required Prescritor cultura,
    required int idadePlantaAno,
    double prnt = 100.0,
  }) {
    double phAtual = analise.ph;
    double min = cultura.phIdeal.min;
    double max = cultura.phIdeal.max;

    bool pHestaIdeal = phAtual >= min && phAtual <= max;

    String mensagempH = pHestaIdeal
        ? "O pH atual ($phAtual) está dentro da faixa ideal para a cultura (${cultura.nome}), variando de $min a $max."
        : "O pH atual ($phAtual) está fora da faixa recomendada ($min a $max). A intervenção via calagem é necessária.";

    // Aciona o motor de cálculos oficiais
    ResultadoCalculo resultadoCalculos = Calculador.calcularRecomendacoesOficiais(
      analise: analise,
      cultura: cultura,
      idadePlantaAno: idadePlantaAno,
      prnt: prnt,
    );

    // Validação de Gessagem baseada na regra de profundidade (20cm = superficial, 40cm = subsolo)
    Calculador calcAux = Calculador();
    bool precisaGesso = calcAux.calcularNecessidadeDeGesso(analise.al, analise.ca);
    
    String avisoGessagem = "";

    if (precisaGesso) {
      if (analise.profundidade <= 20) {
        // Se a amostra foi de 0-20 cm, avisa que o ideal é conferir com a camada de 20-40 cm
        avisoGessagem = "Atenção: Os teores na camada de 0-20 cm indicam alerta (Al > 0,5 ou Ca < 0,5). Para calcular a quantidade exata de gesso agrícola, o ideal é cadastrar uma análise específica da camada de 20-40 cm.";
      } else if (analise.profundidade >= 40) {
        // Se a amostra foi de 20-40 cm (subsolo), calcula o gesso com total precisão!
        double qtdGesso = calcAux.calcularGessagem(resultadoCalculos.necessidadeCalagem);
        avisoGessagem = "Análise de subsolo (20-40 cm) confirma necessidade de gessagem. Recomendação: $qtdGesso t/ha de gesso agrícola.";
      } else {
        double qtdGesso = calcAux.calcularGessagem(resultadoCalculos.necessidadeCalagem);
        avisoGessagem = "Necessidade de gessagem detectada. Recomendação estimada: $qtdGesso t/ha.";
      }
    } else {
      avisoGessagem = "Teores de Alumínio e Cálcio em níveis adequados na camada analisada (${analise.profundidade.toInt()} cm). Sem necessidade de gessagem.";
    }

    return InterpretadorResult(
      pHestaIdeal: pHestaIdeal,
      mensagempH: mensagempH,
      calculos: resultadoCalculos,
      avisoGessagem: avisoGessagem,
    );
  }
}