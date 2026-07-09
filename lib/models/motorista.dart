class Motorista {
  final int? id;
  final String nome;
  final String telefone;
  final String email;
  final String cnh;
  final String cpf;
  final String endereco;
  final DateTime dataNascimento;
  final DateTime dataAdmissao;
  final bool ativo;

  Motorista({
    this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.cnh,
    required this.cpf,
    required this.endereco,
    required this.dataNascimento,
    required this.dataAdmissao,
    this.ativo = true,
  });

  // Converter para Map para banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'cnh': cnh,
      'cpf': cpf,
      'endereco': endereco,
      'dataNascimento': dataNascimento.toIso8601String(),
      'dataAdmissao': dataAdmissao.toIso8601String(),
      'ativo': ativo ? 1 : 0,
    };
  }

  // Criar a partir de Map do banco de dados
  factory Motorista.fromMap(Map<String, dynamic> map) {
    return Motorista(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
      cnh: map['cnh'],
      cpf: map['cpf'],
      endereco: map['endereco'],
      dataNascimento: DateTime.parse(map['dataNascimento']),
      dataAdmissao: DateTime.parse(map['dataAdmissao']),
      ativo: map['ativo'] == 1,
    );
  }

  // Copiar com modificações
  Motorista copyWith({
    int? id,
    String? nome,
    String? telefone,
    String? email,
    String? cnh,
    String? cpf,
    String? endereco,
    DateTime? dataNascimento,
    DateTime? dataAdmissao,
    bool? ativo,
  }) {
    return Motorista(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      cnh: cnh ?? this.cnh,
      cpf: cpf ?? this.cpf,
      endereco: endereco ?? this.endereco,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      dataAdmissao: dataAdmissao ?? this.dataAdmissao,
      ativo: ativo ?? this.ativo,
    );
  }
}
