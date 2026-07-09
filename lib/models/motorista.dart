class Motorista {
  final int? id;
  final String nome;
  final String cpf;
  final String cnh;
  final String categoria;
  final String telefone;

  Motorista({
    this.id,
    required this.nome,
    required this.cpf,
    required this.cnh,
    required this.categoria,
    required this.telefone,
  });

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'cnh': cnh,
      'categoria': categoria,
      'telefone': telefone,
    };
  }

  // Criar a partir de Map do banco de dados
  factory Motorista.fromMap(Map<String, dynamic> map) {
    return Motorista(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'],
      cnh: map['cnh'],
      categoria: map['categoria'],
      telefone: map['telefone'],
    );
  }

  // Copiar com modificações
  Motorista copyWith({
    int? id,
    String? nome,
    String? cpf,
    String? cnh,
    String? categoria,
    String? telefone,
  }) {
    return Motorista(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      cnh: cnh ?? this.cnh,
      categoria: categoria ?? this.categoria,
      telefone: telefone ?? this.telefone,
    );
  }
}
