class Cliente {
  final int? id;
  final String nome;
  final String cpfCnpj;
  final String telefone;
  final String email;
  final String endereco;

  Cliente({
    this.id,
    required this.nome,
    required this.cpfCnpj,
    required this.telefone,
    required this.email,
    required this.endereco,
  });

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cpfCnpj': cpfCnpj,
      'telefone': telefone,
      'email': email,
      'endereco': endereco,
    };
  }

  // Criar a partir de Map do banco de dados
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nome: map['nome'],
      cpfCnpj: map['cpfCnpj'],
      telefone: map['telefone'],
      email: map['email'],
      endereco: map['endereco'],
    );
  }

  // Copiar com modificações
  Cliente copyWith({
    int? id,
    String? nome,
    String? cpfCnpj,
    String? telefone,
    String? email,
    String? endereco,
  }) {
    return Cliente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      endereco: endereco ?? this.endereco,
    );
  }
}
