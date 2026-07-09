class Caminhao {
  final int? id;
  final String placa;
  final String marca;
  final String modelo;
  final int ano;
  final double mediaConsumo;

  Caminhao({
    this.id,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.mediaConsumo,
  });

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'placa': placa,
      'marca': marca,
      'modelo': modelo,
      'ano': ano,
      'mediaConsumo': mediaConsumo,
    };
  }

  // Criar a partir de Map do banco de dados
  factory Caminhao.fromMap(Map<String, dynamic> map) {
    return Caminhao(
      id: map['id'],
      placa: map['placa'],
      marca: map['marca'],
      modelo: map['modelo'],
      ano: map['ano'],
      mediaConsumo: map['mediaConsumo'],
    );
  }

  // Copiar com modificações
  Caminhao copyWith({
    int? id,
    String? placa,
    String? marca,
    String? modelo,
    int? ano,
    double? mediaConsumo,
  }) {
    return Caminhao(
      id: id ?? this.id,
      placa: placa ?? this.placa,
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      ano: ano ?? this.ano,
      mediaConsumo: mediaConsumo ?? this.mediaConsumo,
    );
  }
}
