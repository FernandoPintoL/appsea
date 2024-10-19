import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import '../var_global.dart';

abstract class AbstractModel{
  Database? db;
  String? get dbname => VarGlobales().dbName;
  int? get dbversion => VarGlobales().dbVersion;

  Future<Database?> init() async {
    if(db == null){
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'dblocal.db');
      db = await openDatabase(path, version: 1, onCreate: _onCreate);
    }
    return db!;
  }

  _onCreate(Database db, int version) async{
    await db.execute("CREATE TABLE session (id INTEGER PRIMARY KEY, name TEXT, email TEXT, usernick TEXT, profile_photo_url TEXT, password TEXT, codominio_id INTEGER)");
    await db.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, email TEXT, usernick TEXT, profile_photo_url TEXT, password TEXT)");
    await db.execute("CREATE TABLE condominios (id INTEGER PRIMARY KEY, propietario TEXT, razonSocial TEXT, nit TEXT, cantidad_viviendas INTEGER, perfil_id INTEGER, user_id INTEGER)");
  }

  Future<Database?> getDb() async{
    return await init();
  }

  void close() async {
    if(db != null){
      await db!.close();
      db = null;
    }
  }
}