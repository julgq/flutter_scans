import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';

/*
  Necesitamos usar el patron singlenton para solo poder hacer una sola instancia global
  Cada vez que se genera una instancia, realmente llama a la primera que se creo.
*/
class DBPRovider {
  static Database _database;
  static final DBPRovider db = DBPRovider._();

  DBPRovider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')');
    });
  }

  // CREAR Registros
  nuevoScanRaw(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.rawInsert(
        'INSERT INTO Scans (id, tipo, valor) VALUES (${nuevoScan.id}, ${nuevoScan.tipo}, ${nuevoScan.valor})');
    return res;
  }

  // CREAR Registros - forma más simple
  nuevoSan(ScanModel nuevoScan) async {
    final db = await database;
    final res = db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  // SELECT - Obtener información

  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('Scans',
        where: 'id = ?', whereArgs: [id]); // el signo ? sinigica argumentos
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final res = await db.query('Scans');
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  // UPDATE Actualizar Registros
  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }

  // DELETE Eliminar Registros
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id= ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }


}
