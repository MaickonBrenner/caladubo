class AnaliseSolo {
  final String tipoSolo;
  final double ph;
  final double materiaOrganica;
  final double fosforo;
  final double potassio;

  AnaliseSolo({required this.tipoSolo, 
    required this.ph, 
    required this.materiaOrganica, 
    required this.fosforo,
    required this.potassio});

  Map<String, dynamic> toMap() {
    return {
      'tipoSolo': tipoSolo,
      'ph': ph,
      'materiaOrganica': materiaOrganica,
      'fosforo': fosforo,
      'potassio': potassio
    };
  }

}