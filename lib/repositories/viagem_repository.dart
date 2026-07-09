import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/viagem.dart';

class ViagemRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> inserir(Viagem viagem) async {
    final db = await dbHelper.database;
    return await db.insert(
      'viagens',
      viagem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Viagem>> listar() async {
    final db = await dbHelper.database;
    final resultado = await db.query('viagens', orderBy: 'dataSaida DESC');
    return resultado.map((json) => Viagem.fromMap(json)).toList();
  }

  Future<List<Viagem>> listarPorMotorista(int motoristaId) async {
    final db = await dbHelper.database;
    final resultado = await db.query(
      'viagens',
      where: 'motoristaId = ?',
      whereArgs: [motoristaId],
      orderBy: 'dataSaida DESC',
    );
    return resultado.map((json) => Viagem.fromMap(json)).toList();
  }

  Future<List<Viagem>> listarPorCliente(int clienteId) async {
    final db = await dbHelper.database;
    final resultado = await db.query(
      'viagens',
      where: 'clienteId = ?',
      whereArgs: [clienteId],
      orderBy: 'dataSaida DESC',
    );
    return resultado.map((json) => Viagem.fromMap(json)).toList();
  }

  Future<List<Viagem>> listarPorCaminhao(int caminhaoId) async {
    final db = await dbHelper.database;
    final resultado = await db.query(
      'viagens',
      where: 'caminhaoId = ?',
      whereArgs: [caminhaoId],
      orderBy: 'dataSaida DESC',
    );
    return resultado.map((json) => Viagem.fromMap(json)).toList();
  }

  Future<Viagem?> obterPorId(int id) async {
    final db = await dbHelper.database;
    final resultado = await db.query(
      'viagens',
      where: 'id = ?',
      whereArgs: [id],
    );
    return resultado.isNotEmpty ? Viagem.fromMap(resultado.first) : null;
  }

  Future<int> atualizar(Viagem viagem) async {
    final db = await dbHelper.database;
    return await db.update(
      'viagens',
      viagem.toMap(),
      where: 'id = ?',
      whereArgs: [viagem.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'viagens',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==================== RELATÓRIOS ====================

  Future<double> obterFaturamentoMes() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      SELECT SUM(valorFrete) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> obterLucroMes() async {
    final db = await dbHelper.database;
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

  Future<int> obterTotalViagensDoMes() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return (result.first['total'] as int?) ?? 0;
  }

  Future<double> obterGastoDieselMes() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      SELECT SUM(litrosDiesel * valorLitroDiesel) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> obterGastoArlaMes() async {
    final db = await dbHelper.database;
    final result = await db.rawQuery('''
      SELECT SUM(litrosArla * valorLitroArla) as total FROM viagens 
      WHERE strftime('%Y-%m', dataSaida) = strftime('%Y-%m', 'now')
    ''');
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  Future<double> obterCustoMedioPorKm() async {
    final db = await dbHelper.database;
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
}
