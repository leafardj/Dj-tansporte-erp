class Viagem {
  final int? id;
  final int clienteId;
  final int motoristaId;
  final int caminhaoId;
  final String origem;
  final String destino;
  final double kmInicial;
  final double kmFinal;
  final double litrosDiesel;
  final double valorDiesel;
  final double litrosArla;
  final double valorArla;
  final double pedagio;
  final double outrasDespesas;
  final double valorFrete;

  Viagem({
    this.id,
    required this.clienteId,
    required this.motoristaId,
    required this.caminhaoId,
    required this.origem,
    required this.destino,
    required this.kmInicial,
    required this.kmFinal,
    required this.litrosDiesel,
    required this.valorDiesel,
    required this.litrosArla,
    required this.valorArla,
    required this.pedagio,
    required this.outrasDespesas,
    required this.valorFrete,
  });

  // Propriedades calculadas
  double get distancia => kmFinal - kmInicial;

  double get custoDiesel => litrosDiesel * valorDiesel;

  double get custoArla => litrosArla * valorArla;

  double get custoTotal =>
      custoDiesel + custoArla + pedagio + outrasDespesas;

  double get custoKm => distancia == 0 ? 0 : custoTotal / distancia;

  double get mediaKmLitro => litrosDiesel == 0 ? 0 : distancia / litrosDiesel;

  double get lucro => valorFrete - custoTotal;

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteId': clienteId,
      'motoristaId': motoristaId,
      'caminhaoId': caminhaoId,
      'origem': origem,
      'destino': destino,
      'kmInicial': kmInicial,
      'kmFinal': kmFinal,
      'litrosDiesel': litrosDiesel,
      'valorDiesel': valorDiesel,
      'litrosArla': litrosArla,
      'valorArla': valorArla,
      'pedagio': pedagio,
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
      kmInicial: map['kmInicial'],
      kmFinal: map['kmFinal'],
      litrosDiesel: map['litrosDiesel'],
      valorDiesel: map['valorDiesel'],
      litrosArla: map['litrosArla'],
      valorArla: map['valorArla'],
      pedagio: map['pedagio'],
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
    double? kmInicial,
    double? kmFinal,
    double? litrosDiesel,
    double? valorDiesel,
    double? litrosArla,
    double? valorArla,
    double? pedagio,
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
      kmInicial: kmInicial ?? this.kmInicial,
      kmFinal: kmFinal ?? this.kmFinal,
      litrosDiesel: litrosDiesel ?? this.litrosDiesel,
      valorDiesel: valorDiesel ?? this.valorDiesel,
      litrosArla: litrosArla ?? this.litrosArla,
      valorArla: valorArla ?? this.valorArla,
      pedagio: pedagio ?? this.pedagio,
      outrasDespesas: outrasDespesas ?? this.outrasDespesas,
      valorFrete: valorFrete ?? this.valorFrete,
    );
  }
}
