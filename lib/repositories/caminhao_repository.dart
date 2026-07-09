import 'package:sqflite/sqflite.dart';

import '../database/database_helper.dart';
import '../models/caminhao.dart';

class CaminhaoRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> inserir(Caminhao caminhao) async {
    final db = await dbHelper.database;
    return await db.insert(
      'caminhoes',
      caminhao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Caminhao>> listar() async {
    final db = await dbHelper.database;
    final resultado = await db.query('caminhoes', orderBy: 'placa ASC');
    return resultado.map((json) => Caminhao.fromMap(json)).toList();
  }

  Future<Caminhao?> obterPorId(int id) async {
    final db = await dbHelper.database;
    final resultado = await db.query(
      'caminhoes',
      where: 'id = ?',
      whereArgs: [id],
    );
    return resultado.isNotEmpty ? Caminhao.fromMap(resultado.first) : null;
  }

  Future<int> atualizar(Caminhao caminhao) async {
    final db = await dbHelper.database;
    return await db.update(
      'caminhoes',
      caminhao.toMap(),
      where: 'id = ?',
      whereArgs: [caminhao.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'caminhoes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
