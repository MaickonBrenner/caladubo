class AnaliseSolo {
  int? id;
  String titulo;
  String data;
  double profundidade;
  double argila;
  double mo;
  double ph;
  double al;
  double h;
  double p;
  double k;
  double ca;
  double mg;
  double na;
  String detalhes; // Para guardar o diagnóstico (V%, CTC, Aviso)

  AnaliseSolo({
    this.id,
    required this.titulo,
    required this.data,
    this.profundidade = 0,
    this.argila = 0,
    this.mo = 0,
    this.ph = 0,
    this.al = 0,
    this.h = 0,
    this.p = 0,
    this.k = 0,
    this.ca = 0,
    this.mg = 0,
    this.na = 0,
    this.detalhes = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'data': data,
      'profundidade': profundidade,
      'argila': argila,
      'mo': mo,
      'ph': ph,
      'al': al,
      'h': h,
      'p': p,
      'k': k,
      'ca': ca,
      'mg': mg,
      'na': na,
      'detalhes': detalhes,
    };
  }
}