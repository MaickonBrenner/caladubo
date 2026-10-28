class Prescritor {
  final String nome;
  final String resumo;
  final List<String> recomendacoes;
  final PhIdeal phIdeal;
  final String metodoCalagem;    // Ex: "MAIOR_QUANTIDADE" ou "SOMATORIO"
  final String unidadeAdubacao;  // Ex: "g/planta" ou "kg/ha"
  final List<AdubacaoAno> tabelaAdubacao;

  Prescritor({
    required this.nome,
    required this.resumo,
    required this.recomendacoes,
    required this.phIdeal,
    required this.metodoCalagem,
    required this.unidadeAdubacao,
    required this.tabelaAdubacao,
  });

  factory Prescritor.fromJson(Map<String, dynamic> json) {
    var listaAdubacao = (json['tabelaAdubacao'] as List?)
            ?.map((item) => AdubacaoAno.fromJson(item))
            .toList() ??
        [];

    return Prescritor(
      nome: json['nome'] ?? '',
      resumo: json['resumo'] ?? '',
      recomendacoes: List<String>.from(json['recomendacoes'] ?? []),
      phIdeal: PhIdeal.fromJson(json['phIdeal'] ?? {}),
      metodoCalagem: json['metodoCalagem'] ?? 'MAIOR_QUANTIDADE', // Padrão seguro
      unidadeAdubacao: json['unidadeAdubacao'] ?? 'g/planta',     // Padrão seguro
      tabelaAdubacao: listaAdubacao,
    );
  }
}

class PhIdeal {
  final double min;
  final double max;
  PhIdeal({required this.min, required this.max});

  factory PhIdeal.fromJson(Map<String, dynamic> json) {
    return PhIdeal(
      min: (json['min'] as num?)?.toDouble() ?? 0.0,
      max: (json['max'] as num?)?.toDouble() ?? 14.0,
    );
  }
}

class AdubacaoAno {
  final String epoca;
  final double n;
  final List<double> p2o5;
  final List<double> k2o;

  AdubacaoAno({
    required this.epoca,
    required this.n,
    required this.p2o5,
    required this.k2o,
  });

  factory AdubacaoAno.fromJson(Map<String, dynamic> json) {
    return AdubacaoAno(
      epoca: json['epoca'] ?? '',
      n: (json['n'] as num?)?.toDouble() ?? 0.0,
      p2o5: List<double>.from((json['p2o5'] ?? []).map((e) => (e as num).toDouble())),
      k2o: List<double>.from((json['k2o'] ?? []).map((e) => (e as num).toDouble())),
    );
  }
}