import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/viagem.dart';
import '../models/cliente.dart';
import '../models/motorista.dart';
import '../models/caminhao.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'dj_transportes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela Clientes
    await db.execute('''
      CREATE TABLE clientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        telefone TEXT,
        email TEXT,
        endereco TEXT,
        cidade TEXT,
        estado TEXT,
        cnpj TEXT UNIQUE,
        dataCadastro TEXT NOT NULL
      )
    ''');

    // Tabela Motoristas
    await db.execute('''
      CREATE TABLE motoristas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        telefone TEXT,
        email TEXT,
        cnh TEXT UNIQUE,
        cpf TEXT UNIQUE,
        endereco TEXT,
        dataNascimento TEXT NOT NULL,
        dataAdmissao TEXT NOT NULL,
        ativo INTEGER DEFAULT 1
      )
    ''');

    // Tabela Caminhões
    await db.execute('''
      CREATE TABLE caminhoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        placa TEXT UNIQUE NOT NULL,
        modelo TEXT NOT NULL,
        marca TEXT NOT NULL,
        ano INTEGER,
        cor TEXT,
        quilometragem REAL DEFAULT 0,
        dataAquisicao TEXT NOT NULL,
        proximaRevisao TEXT,
        ativo INTEGER DEFAULT 1,
        observacoes TEXT
      )
    ''');

    // Tabela Viagens
    await db.execute('''
      CREATE TABLE viagens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clienteId INTEGER NOT NULL,
        motoristaId INTEGER NOT NULL,
        caminhaoId INTEGER NOT NULL,
        origem TEXT NOT NULL,
        destino TEXT NOT NULL,
        quilometragemInicial REAL NOT NULL,
        quilometragemFinal REAL NOT NULL,
        valorFrete REAL NOT NULL,
        dataSaida TEXT NOT NULL,
        dataChegada TEXT,
        status TEXT DEFAULT 'planejada',
        dieselGasto REAL,
        arlaGasto REAL,
        observacoes TEXT,
        FOREIGN KEY (clienteId) REFERENCES clientes(id),
        FOREIGN KEY (motoristaId) REFERENCES motoristas(id),
        FOREIGN KEY (caminhaoId) REFERENCES caminhoes(id)
      )
    ''');
  }

  // ==================== CLIENTES ====================

  Future<int> criarCliente(Cliente cliente) async {
    final db = await database;
    return await db.insert('clientes', cliente.toMap());
  }

  Future<List<Cliente>> obterClientes() async {
    final db = await database;
    final maps = await db.query('clientes');
    return List.generate(maps.length, (i) => Cliente.fromMap(maps[i]));
  }

  Future<Cliente?> obterClientePorId(int id) async {
    final db = await database;
    final maps = await db.query(
      'clientes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Cliente.fromMap(maps.first);
    }
    return null;
  }

  Future<int> atualizarCliente(Cliente cliente) async {
    final db = await database;
    return await db.update(
      'clientes',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<int> deletarCliente(int id) async {
    final db = await database;
    return await db.delete(
      'clientes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== MOTORISTAS ====================

  Future<int> criarMotorista(Motorista motorista) async {
    final db = await database;
    return await db.insert('motoristas', motorista.toMap());
  }

  Future<List<Motorista>> obterMotoristas() async {
    final db = await database;
    final maps = await db.query('motoristas');
    return List.generate(maps.length, (i) => Motorista.fromMap(maps[i]));
  }

  Future<List<Motorista>> obterMotoristasAtivos() async {
    final db = await database;
    final maps = await db.query(
      'motoristas',
      where: 'ativo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Motorista.fromMap(maps[i]));
  }

  Future<Motorista?> obterMotoristaPorId(int id) async {
    final db = await database;
    final maps = await db.query(
      'motoristas',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Motorista.fromMap(maps.first);
    }
    return null;
  }

  Future<int> atualizarMotorista(Motorista motorista) async {
    final db = await database;
    return await db.update(
      'motoristas',
      motorista.toMap(),
      where: 'id = ?',
      whereArgs: [motorista.id],
    );
  }

  Future<int> deletarMotorista(int id) async {
    final db = await database;
    return await db.delete(
      'motoristas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== CAMINHÕES ====================

  Future<int> criarCaminhao(Caminhao caminhao) async {
    final db = await database;
    return await db.insert('caminhoes', caminhao.toMap());
  }

  Future<List<Caminhao>> obterCaminhoes() async {
    final db = await database;
    final maps = await db.query('caminhoes');
    return List.generate(maps.length, (i) => Caminhao.fromMap(maps[i]));
  }

  Future<List<Caminhao>> obterCaminhoesAtivos() async {
    final db = await database;
    final maps = await db.query(
      'caminhoes',
      where: 'ativo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Caminhao.fromMap(maps[i]));
  }

  Future<Caminhao?> obterCaminhaoPorId(int id) async {
    final db = await database;
    final maps = await db.query(
      'caminhoes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Caminhao.fromMap(maps.first);
    }
    return null;
  }

  Future<int> atualizarCaminhao(Caminhao caminhao) async {
    final db = await database;
    return await db.update(
      'caminhoes',
      caminhao.toMap(),
      where: 'id = ?',
      whereArgs: [caminhao.id],
    );
  }

  Future<int> deletarCaminhao(int id) async {
    final db = await database;
    return await db.delete(
      'caminhoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== VIAGENS ====================

  Future<int> criarViagem(Viagem viagem) async {
    final db = await database;
    return await db.insert('viagens', viagem.toMap());
  }

  Future<List<Viagem>> obterViagens() async {
    final db = await database;
    final maps = await db.query('viagens');
    return List.generate(maps.length, (i) => Viagem.fromMap(maps[i]));
  }

  Future<List<Viagem>> obterViagensPorStatus(String status) async {
    final db = await database;
    final maps = await db.query(
      'viagens',
      where: 'status = ?',
      whereArgs: [status],
    );
    return List.generate(maps.length, (i) => Viagem.fromMap(maps[i]));
  }

  Future<List<Viagem>> obterViagensPorMotorista(int motoristaId) async {
    final db = await database;
    final maps = await db.query(
      'viagens',
      where: 'motoristaId = ?',
      whereArgs: [motoristaId],
    );
    return List.generate(maps.length, (i) => Viagem.fromMap(maps[i]));
  }

  Future<List<Viagem>> obterViagensPorCliente(int clienteId) async {
    final db = await database;
    final maps = await db.query(
      'viagens',
      where: 'clienteId = ?',
      whereArgs: [clienteId],
    );
    return List.generate(maps.length, (i) => Viagem.fromMap(maps[i]));
  }

  Future<Viagem?> obterViagemPorId(int id) async {
    final db = await database;
    final maps = await db.query(
      'viagens',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Viagem.fromMap(maps.first);
    }
    return null;
  }

  Future<int> atualizarViagem(Viagem viagem) async {
    final db = await database;
    return await db.update(
      'viagens',
      viagem.toMap(),
      where: 'id = ?',
      whereArgs: [viagem.id],
    );
  }

  Future<int> deletarViagem(int id) async {
    final db = await database;
    return await db.delete(
      'viagens',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== RELATÓRIOS ====================

  Future<double> obterFaturamentoMes() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(valorFrete) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> obterLucroMes() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(valorFrete - COALESCE(dieselGasto, 0) - COALESCE(arlaGasto, 0)) as total 
      FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<int> obterTotalViagensAtivas() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as total FROM viagens 
      WHERE status IN ('planejada', 'emAndamento')
    ''');
    return result.first['total'] as int? ?? 0;
  }

  Future<double> obterGastoDieselMes() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(dieselGasto) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> obterGastoArlaMes() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(arlaGasto) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return result.first['total'] as double? ?? 0.0;
  }

  Future<double> obterCustoMedioPorKm() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT 
        SUM(dieselGasto + COALESCE(arlaGasto, 0)) / 
        SUM(quilometragemFinal - quilometragemInicial) as media
      FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return result.first['media'] as double? ?? 0.0;
  }

  // ==================== LIMPEZA ====================

  Future<void> limparBancoDados() async {
    final db = await database;
    await db.delete('viagens');
    await db.delete('motoristas');
    await db.delete('caminhoes');
    await db.delete('clientes');
  }
}
