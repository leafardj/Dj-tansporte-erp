import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/motorista.dart';

class MotoristRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> inserir(Motorista motorista) async {
    final db = await dbHelper.database;
    return await db.insert(
      'motoristas',
      motorista.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Motorista>> listar() async {
    final db = await dbHelper.database;
    final resultado = await db.query('motoristas', orderBy: 'nome ASC');
    return resultado.map((json) => Motorista.fromMap(json)).toList();
  }

  Future<Motorista?> obterPorId(int id) async {
    final db = await dbHelper.database;
    final resultado = await db.query(
      'motoristas',
      where: 'id = ?',
      whereArgs: [id],
    );
    return resultado.isNotEmpty ? Motorista.fromMap(resultado.first) : null;
  }

  Future<int> atualizar(Motorista motorista) async {
    final db = await dbHelper.database;
    return await db.update(
      'motoristas',
      motorista.toMap(),
      where: 'id = ?',
      whereArgs: [motorista.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'motoristas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
