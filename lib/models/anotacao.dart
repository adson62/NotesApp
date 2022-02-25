import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Anotacao {
  int? id;
  final String titulo;
  final String texto;
  final DateTime dataCriacao;
  final int done;

  Anotacao(
      {this.id,
      required this.titulo,
      required this.texto,
      required this.dataCriacao,
      required this.done});

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'texto': texto,
      'dataCriacao': dataCriacao,
      'done': done,
    };
  }
}

Future<Database> databaseCreate() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'anotacoes.db'),
    onCreate: (db, version) => db.execute(
        'CREATE TABLE Anotacao (id INTEGER PRIMARY KEY, texto TEXT, titulo TEXT, dataCriacao DATETIME, done INTEGER)'),
    version: 1,
  );
  return database;
}

Future<void> createNote(Anotacao anotacao) async {
  final db = await databaseCreate();

  db.insert('Anotacao', anotacao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
}

Future<List<Anotacao>> getNote() async {
  final db = await databaseCreate();

  final List<Map<String, dynamic>> all = await db.query('Anotacao');

  return List.generate(all.length, (i) {
    return Anotacao(
      id: all[i]['id'],
      titulo: all[i]['titulo'],
      texto: all[i]['texto'],
      dataCriacao: all[i]['dataCriacao'],
      done: all[i]['done'],
    );
  });
}

Future<void> updateNote(Anotacao anotacao) async {
  final db = await databaseCreate();

  db.update('Anotacao', anotacao.toMap(),
      where: 'id = ?', whereArgs: [anotacao.id]);
}

Future<void> deleteNote(Anotacao anotacao) async {
  final db = await databaseCreate();

  db.delete('Anotacao', where: 'id = ?', whereArgs: [anotacao.id]);
}
