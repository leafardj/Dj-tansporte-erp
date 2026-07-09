import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dj_transportes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Tabela Clientes
    await db.execute('''
      CREATE TABLE clientes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        cpfCnpj TEXT UNIQUE,
        telefone TEXT,
        email TEXT,
        endereco TEXT
      )
    ''');

    // Tabela Motoristas
    await db.execute('''
      CREATE TABLE motoristas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        cpf TEXT UNIQUE,
        cnh TEXT UNIQUE,
        categoria TEXT,
        telefone TEXT
      )
    ''');

    // Tabela Caminhões
    await db.execute('''
      CREATE TABLE caminhoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        placa TEXT UNIQUE NOT NULL,
        marca TEXT NOT NULL,
        modelo TEXT NOT NULL,
        ano INTEGER,
        mediaConsumo REAL
      )
    ''');

    // Tabela Viagens
    await db.execute('''
      CREATE TABLE viagens(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clienteId INTEGER NOT NULL,
        motoristaId INTEGER NOT NULL,
        caminhaoId INTEGER NOT NULL,
        origem TEXT NOT NULL,
        destino TEXT NOT NULL,
        dataSaida TEXT NOT NULL,
        dataChegada TEXT,
        kmInicial REAL NOT NULL,
        kmFinal REAL NOT NULL,
        litrosDiesel REAL NOT NULL,
        valorLitroDiesel REAL NOT NULL,
        litrosArla REAL NOT NULL,
        valorLitroArla REAL NOT NULL,
        pedagios REAL,
        alimentacao REAL,
        hospedagem REAL,
        outrasDespesas REAL,
        valorFrete REAL NOT NULL,
        FOREIGN KEY (clienteId) REFERENCES clientes(id),
        FOREIGN KEY (motoristaId) REFERENCES motoristas(id),
        FOREIGN KEY (caminhaoId) REFERENCES caminhoes(id)
      )
    ''');
  }

  // ==================== CLIENTES ====================

  Future<int> inserirCliente(Map<String, dynamic> cliente) async {
    final db = await database;
    return await db.insert(
      'clientes',
      cliente,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> listarClientes() async {
    final db = await database;
    return await db.query('clientes', orderBy: 'nome ASC');
  }

  Future<Map<String, dynamic>?> obterClientePorId(int id) async {
    final db = await database;
    final resultado = await db.query(
      'clientes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return resultado.isNotEmpty ? resultado.first : null;
  }

  Future<int> atualizarCliente(int id, Map<String, dynamic> cliente) async {
    final db = await database;
    return await db.update(
      'clientes',
      cliente,
      where: 'id = ?',
      whereArgs: [id],
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

  Future<int> inserirMotorista(Map<String, dynamic> motorista) async {
    final db = await database;
    return await db.insert(
      'motoristas',
      motorista,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> listarMotoristas() async {
    final db = await database;
    return await db.query('motoristas', orderBy: 'nome ASC');
  }

  Future<Map<String, dynamic>?> obterMotoristaPorId(int id) async {
    final db = await database;
    final resultado = await db.query(
      'motoristas',
      where: 'id = ?',
      whereArgs: [id],
    );
    return resultado.isNotEmpty ? resultado.first : null;
  }

  Future<int> atualizarMotorista(int id, Map<String, dynamic> motorista) async {
    final db = await database;
    return await db.update(
      'motoristas',
      motorista,
      where: 'id = ?',
      whereArgs: [id],
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

  Future<int> inserirCaminhao(Map<String, dynamic> caminhao) async {
    final db = await database;
    return await db.insert(
      'caminhoes',
      caminhao,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> listarCaminhoes() async {
    final db = await database;
    return await db.query('caminhoes', orderBy: 'placa ASC');
  }

  Future<Map<String, dynamic>?> obterCaminhaoPorId(int id) async {
    final db = await database;
    final resultado = await db.query(
      'caminhoes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return resultado.isNotEmpty ? resultado.first : null;
  }

  Future<int> atualizarCaminhao(int id, Map<String, dynamic> caminhao) async {
    final db = await database;
    return await db.update(
      'caminhoes',
      caminhao,
      where: 'id = ?',
      whereArgs: [id],
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

  Future<int> inserirViagem(Map<String, dynamic> viagem) async {
    final db = await database;
    return await db.insert(
      'viagens',
      viagem,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> listarViagens() async {
    final db = await database;
    return await db.query('viagens', orderBy: 'dataSaida DESC');
  }

  Future<List<Map<String, dynamic>>> listarViagensPorMotorista(int motoristaId) async {
    final db = await database;
    return await db.query(
      'viagens',
      where: 'motoristaId = ?',
      whereArgs: [motoristaId],
      orderBy: 'dataSaida DESC',
    );
  }

  Future<List<Map<String, dynamic>>> listarViagensPorCliente(int clienteId) async {
    final db = await database;
    return await db.query(
      'viagens',
      where: 'clienteId = ?',
      whereArgs: [clienteId],
      orderBy: 'dataSaida DESC',
    );
  }

  Future<List<Map<String, dynamic>>> listarViagensPorCaminhao(int caminhaoId) async {
    final db = await database;
    return await db.query(
      'viagens',
      where: 'caminhaoId = ?',
      whereArgs: [caminhaoId],
      orderBy: 'dataSaida DESC',
    );
  }

  Future<Map<String, dynamic>?> obterViagemPorId(int id) async {
    final db = await database;
    final resultado = await db.query(
      'viagens',
      where: 'id = ?',
      whereArgs: [id],
    );
    return resultado.isNotEmpty ? resultado.first : null;
  }

  Future<int> atualizarViagem(int id, Map<String, dynamic> viagem) async {
    final db = await database;
    return await db.update(
      'viagens',
      viagem,
      where: 'id = ?',
      whereArgs: [id],
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
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> obterLucroMes() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(
        valorFrete - (
          litrosDiesel * valorLitroDiesel +
          litrosArla * valorLitroArla +
          pedagios +
          alimentacao +
          hospedagem +
          outrasDespesas
        )
      ) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<int> obterTotalViagens() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return (result.first['total'] as int?) ?? 0;
  }

  Future<double> obterGastoDieselMes() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(litrosDiesel * valorLitroDiesel) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> obterGastoArlaMes() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(litrosArla * valorLitroArla) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> obterCustoMedioPorKm() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT 
        SUM(
          litrosDiesel * valorLitroDiesel +
          litrosArla * valorLitroArla +
          pedagios +
          alimentacao +
          hospedagem +
          outrasDespesas
        ) / 
        SUM(kmFinal - kmInicial) as media
      FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
        AND (kmFinal - kmInicial) > 0
    ''');
    return (result.first['media'] as num?)?.toDouble() ?? 0.0;
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
