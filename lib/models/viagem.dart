enum StatusViagem {
  planejada,
  emAndamento,
  finalizada,
  cancelada,
}

class Viagem {
  final int? id;
  final int clienteId;
  final int motoristaId;
  final int caminhaoId;
  final String origem;
  final String destino;
  final double quilometragemInicial;
  final double quilometragemFinal;
  final double valorFrete;
  final DateTime dataSaida;
  final DateTime? dataChegada;
  final StatusViagem status;
  final double? dieselGasto;
  final double? arlaGasto;
  final String? observacoes;

  Viagem({
    this.id,
    required this.clienteId,
    required this.motoristaId,
    required this.caminhaoId,
    required this.origem,
    required this.destino,
    required this.quilometragemInicial,
    required this.quilometragemFinal,
    required this.valorFrete,
    required this.dataSaida,
    this.dataChegada,
    this.status = StatusViagem.planejada,
    this.dieselGasto,
    this.arlaGasto,
    this.observacoes,
  });

  // Calcular quilometragem da viagem
  double get quilometragemViagem => quilometragemFinal - quilometragemInicial;

  // Calcular custo por km
  double get custoPorKm {
    if (quilometragemViagem == 0) return 0;
    return (dieselGasto ?? 0) / quilometragemViagem;
  }

  // Calcular lucro líquido
  double get lucroLiquido {
    return valorFrete - (dieselGasto ?? 0) - (arlaGasto ?? 0);
  }

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'motoristaId': motoristaId,
      'caminhaoId': caminhaoId,
      'origem': origem,
      'destino': destino,
      'quilometragemInicial': quilometragemInicial,
      'quilometragemFinal': quilometragemFinal,
      'valorFrete': valorFrete,
      'dataSaida': dataSaida.toIso8601String(),
      'dataChegada': dataChegada?.toIso8601String(),
      'status': status.toString().split('.').last,
      'dieselGasto': dieselGasto,
      'arlaGasto': arlaGasto,
      'observacoes': observacoes,
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
      quilometragemInicial: map['quilometragemInicial'],
      quilometragemFinal: map['quilometragemFinal'],
      valorFrete: map['valorFrete'],
      dataSaida: DateTime.parse(map['dataSaida']),
      dataChegada: map['dataChegada'] != null
          ? DateTime.parse(map['dataChegada'])
          : null,
      status: StatusViagem.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
      ),
      dieselGasto: map['dieselGasto'],
      arlaGasto: map['arlaGasto'],
      observacoes: map['observacoes'],
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
    double? quilometragemInicial,
    double? quilometragemFinal,
    double? valorFrete,
    DateTime? dataSaida,
    DateTime? dataChegada,
    StatusViagem? status,
    double? dieselGasto,
    double? arlaGasto,
    String? observacoes,
  }) {
    return Viagem(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      motoristaId: motoristaId ?? this.motoristaId,
      caminhaoId: caminhaoId ?? this.caminhaoId,
      origem: origem ?? this.origem,
      destino: destino ?? this.destino,
      quilometragemInicial: quilometragemInicial ?? this.quilometragemInicial,
      quilometragemFinal: quilometragemFinal ?? this.quilometragemFinal,
      valorFrete: valorFrete ?? this.valorFrete,
      dataSaida: dataSaida ?? this.dataSaida,
      dataChegada: dataChegada ?? this.dataChegada,
      status: status ?? this.status,
      dieselGasto: dieselGasto ?? this.dieselGasto,
      arlaGasto: arlaGasto ?? this.arlaGasto,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
