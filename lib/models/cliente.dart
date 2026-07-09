class Cliente {
  final int? id;
  final String nome;
  final String telefone;
  final String email;
  final String endereco;
  final String cidade;
  final String estado;
  final String cnpj;
  final DateTime dataCadastro;

  Cliente({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.endereco,
    required this.cidade,
    required this.estado,
    required this.cnpj,
    required this.dataCadastro,
  });

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'endereco': endereco,
      'cidade': cidade,
      'estado': estado,
      'cnpj': cnpj,
      'dataCadastro': dataCadastro.toIso8601String(),
    };
  }

  // Criar a partir de Map do banco de dados
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
      endereco: map['endereco'],
      cidade: map['cidade'],
      estado: map['estado'],
      cnpj: map['cnpj'],
      dataCadastro: DateTime.parse(map['dataCadastro']),
    );
  }

  // Copiar com modificações
  Cliente copyWith({
    int? id,
    String? nome,
    String? telefone,
    String? email,
    String? endereco,
    String? cidade,
    String? estado,
    String? cnpj,
    DateTime? dataCadastro,
  }) {
    return Cliente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      endereco: endereco ?? this.endereco,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      cnpj: cnpj ?? this.cnpj,
      dataCadastro: dataCadastro ?? this.dataCadastro,
    );
  }
}
