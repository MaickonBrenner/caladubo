import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/analiseSoloModel.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _database;

  DBHelper._internal();
  factory DBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'caladubo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE analises (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            data TEXT,
            profundidade REAL,
            argila REAL,
            mo REAL,
            ph REAL,
            al REAL,
            h REAL,
            p REAL,
            k REAL,
            ca REAL,
            mg REAL,
            na REAL,
            detalhes TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertAnalise(AnaliseSolo analise) async {
    final db = await database;
    return await db.insert('analises', analise.toMap());
  }

  Future<List<AnaliseSolo>> getAnalises() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('analises', orderBy: "id DESC");
    return List.generate(maps.length, (i) => AnaliseSolo(
      id: maps[i]['id'],
      titulo: maps[i]['titulo'],
      data: maps[i]['data'],
      profundidade: maps[i]['profundidade'],
      argila: maps[i]['argila'],
      mo: maps[i]['mo'],
      ph: maps[i]['ph'],
      al: maps[i]['al'],
      h: maps[i]['h'],
      p: maps[i]['p'],
      k: maps[i]['k'],
      ca: maps[i]['ca'],
      mg: maps[i]['mg'],
      na: maps[i]['na'],
      detalhes: maps[i]['detalhes'],
    ));
  }

  Future<int> updateAnalise(AnaliseSolo analise) async {
    final db = await database;
    return await db.update(
      'analises',
      analise.toMap(),
      where: 'id = ?',
      whereArgs: [analise.id],
    );
  }

  Future<int> deleteAnalise(int id) async {
    final db = await database;
    return await db.delete(
      'analises',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}