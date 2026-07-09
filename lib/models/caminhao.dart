class Caminhao {
  final int? id;
  final String placa;
  final String modelo;
  final String marca;
  final int ano;
  final String cor;
  final double quilometragem;
  final DateTime dataAquisicao;
  final DateTime? proximaRevisao;
  final bool ativo;
  final String? observacoes;

  Caminhao({
    this.id,
    required this.placa,
    required this.modelo,
    required this.marca,
    required this.ano,
    required this.cor,
    required this.quilometragem,
    required this.dataAquisicao,
    this.proximaRevisao,
    this.ativo = true,
    this.observacoes,
  });

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placa': placa,
      'modelo': modelo,
      'marca': marca,
      'ano': ano,
      'cor': cor,
      'quilometragem': quilometragem,
      'dataAquisicao': dataAquisicao.toIso8601String(),
      'proximaRevisao': proximaRevisao?.toIso8601String(),
      'ativo': ativo ? 1 : 0,
      'observacoes': observacoes,
    };
  }

  // Criar a partir de Map do banco de dados
  factory Caminhao.fromMap(Map<String, dynamic> map) {
    return Caminhao(
      id: map['id'],
      placa: map['placa'],
      modelo: map['modelo'],
      marca: map['marca'],
      ano: map['ano'],
      cor: map['cor'],
      quilometragem: map['quilometragem'],
      dataAquisicao: DateTime.parse(map['dataAquisicao']),
      proximaRevisao: map['proximaRevisao'] != null
          ? DateTime.parse(map['proximaRevisao'])
          : null,
      ativo: map['ativo'] == 1,
      observacoes: map['observacoes'],
    );
  }

  // Copiar com modificações
  Caminhao copyWith({
    int? id,
    String? placa,
    String? modelo,
    String? marca,
    int? ano,
    String? cor,
    double? quilometragem,
    DateTime? dataAquisicao,
    DateTime? proximaRevisao,
    bool? ativo,
    String? observacoes,
  }) {
    return Caminhao(
      id: id ?? this.id,
      placa: placa ?? this.placa,
      modelo: modelo ?? this.modelo,
      marca: marca ?? this.marca,
      ano: ano ?? this.ano,
      cor: cor ?? this.cor,
      quilometragem: quilometragem ?? this.quilometragem,
      dataAquisicao: dataAquisicao ?? this.dataAquisicao,
      proximaRevisao: proximaRevisao ?? this.proximaRevisao,
      ativo: ativo ?? this.ativo,
      observacoes: observacoes ?? this.observacoes,
    );
  }
}
