class Viagem {
  final int? id;
  final int clienteId;
  final int motoristaId;
  final int caminhaoId;
  final String origem;
  final String destino;
  final DateTime dataSaida;
  final DateTime? dataChegada;
  final double kmInicial;
  final double kmFinal;
  final double litrosDiesel;
  final double valorLitroDiesel;
  final double litrosArla;
  final double valorLitroArla;
  final double pedagios;
  final double alimentacao;
  final double hospedagem;
  final double outrasDespesas;
  final double valorFrete;

  Viagem({
    this.id,
    required this.clienteId,
    required this.motoristaId,
    required this.caminhaoId,
    required this.origem,
    required this.destino,
    required this.dataSaida,
    this.dataChegada,
    required this.kmInicial,
    required this.kmFinal,
    required this.litrosDiesel,
    required this.valorLitroDiesel,
    required this.litrosArla,
    required this.valorLitroArla,
    required this.pedagios,
    required this.alimentacao,
    required this.hospedagem,
    required this.outrasDespesas,
    required this.valorFrete,
  });

  // Propriedades calculadas
  double get distancia => kmFinal - kmInicial;

  double get custoDiesel => litrosDiesel * valorLitroDiesel;

  double get custoArla => litrosArla * valorLitroArla;

  double get custoTotal =>
      custoDiesel + custoArla + pedagios + alimentacao + hospedagem + outrasDespesas;

  double get custoPorKm => distancia <= 0 ? 0 : custoTotal / distancia;

  double get mediaKmLitro => litrosDiesel <= 0 ? 0 : distancia / litrosDiesel;

  double get lucroLiquido => valorFrete - custoTotal;

  double get margemLucro =>
      valorFrete <= 0 ? 0 : (lucroLiquido / valorFrete) * 100;

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'motoristaId': motoristaId,
      'caminhaoId': caminhaoId,
      'origem': origem,
      'destino': destino,
      'dataSaida': dataSaida.toIso8601String(),
      'dataChegada': dataChegada?.toIso8601String(),
      'kmInicial': kmInicial,
      'kmFinal': kmFinal,
      'litrosDiesel': litrosDiesel,
      'valorLitroDiesel': valorLitroDiesel,
      'litrosArla': litrosArla,
      'valorLitroArla': valorLitroArla,
      'pedagios': pedagios,
      'alimentacao': alimentacao,
      'hospedagem': hospedagem,
      'outrasDespesas': outrasDespesas,
      'valorFrete': valorFrete,
    };
  }

  // Criar a partir de Map do banco de dados
  factory Viagem.fromMap(Map<String, dynamic> map) {
    return Viagem(
      id: map['id'],
      clienteId: map['clienteId'],
      motoristaId: map['motoristaId'],
      caminhaoId: map['caminhaoId'],
      origem: map['origem'],
      destino: map['destino'],
      dataSaida: DateTime.parse(map['dataSaida']),
      dataChegada: map['dataChegada'] != null
          ? DateTime.parse(map['dataChegada'])
          : null,
      kmInicial: map['kmInicial'],
      kmFinal: map['kmFinal'],
      litrosDiesel: map['litrosDiesel'],
      valorLitroDiesel: map['valorLitroDiesel'],
      litrosArla: map['litrosArla'],
      valorLitroArla: map['valorLitroArla'],
      pedagios: map['pedagios'],
      alimentacao: map['alimentacao'],
      hospedagem: map['hospedagem'],
      outrasDespesas: map['outrasDespesas'],
      valorFrete: map['valorFrete'],
    );
  }

  // Copiar com modificações
  Viagem copyWith({
    int? id,
    int? clienteId,
    int? motoristaId,
    int? caminhaoId,
    String? origem,
    String? destino,
    DateTime? dataSaida,
    DateTime? dataChegada,
    double? kmInicial,
    double? kmFinal,
    double? litrosDiesel,
    double? valorLitroDiesel,
    double? litrosArla,
    double? valorLitroArla,
    double? pedagios,
    double? alimentacao,
    double? hospedagem,
    double? outrasDespesas,
    double? valorFrete,
  }) {
    return Viagem(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      motoristaId: motoristaId ?? this.motoristaId,
      caminhaoId: caminhaoId ?? this.caminhaoId,
      origem: origem ?? this.origem,
      destino: destino ?? this.destino,
      dataSaida: dataSaida ?? this.dataSaida,
      dataChegada: dataChegada ?? this.dataChegada,
      kmInicial: kmInicial ?? this.kmInicial,
      kmFinal: kmFinal ?? this.kmFinal,
      litrosDiesel: litrosDiesel ?? this.litrosDiesel,
      valorLitroDiesel: valorLitroDiesel ?? this.valorLitroDiesel,
      litrosArla: litrosArla ?? this.litrosArla,
      valorLitroArla: valorLitroArla ?? this.valorLitroArla,
      pedagios: pedagios ?? this.pedagios,
      alimentacao: alimentacao ?? this.alimentacao,
      hospedagem: hospedagem ?? this.hospedagem,
      outrasDespesas: outrasDespesas ?? this.outrasDespesas,
      valorFrete: valorFrete ?? this.valorFrete,
    );
  }
}
