import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/models/base64_image.dart';

class DB {
  static final DB instance = DB._init();
  static Database? _database;
  DB._init();

  get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase('dataocr.db');
    return _database!;
  }

  Future<Database> _initDatabase(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    // FOR CLEAR THE DATABASE
    // await deleteDatabase(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE base64_imagem (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        valuebase64 TEXT
      );
      ''');
  }

  newBase64(Base64Image newBase64) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT INTO base64_imagem(id,valuebase64) VALUES(${newBase64.id}, '${newBase64.base64Data.toString()}')");
    return res;
  }

  getBase64(int id) async {
    final db = await database;
    var res = await db.query("base64_imagem", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Base64Image.fromMap(res.first) : Null;
  }

  getAllBase64() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM base64_imagem');
    return res;
  }

  getCount() async {
    Database db = await database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from base64_imagem');

    int? resultado = Sqflite.firstIntValue(x);
    return resultado!;
  }

  deleteBase64(int id) async {
    final db = await database;
    db.delete("base64_imagem", where: "id = ?", whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
