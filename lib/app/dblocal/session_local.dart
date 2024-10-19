import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';
import '../var_global.dart';
import 'dblocal.dart';

class UserSessionLocal extends AbstractModel {
  static UserSessionLocal? _this;
  factory UserSessionLocal() {
    _this ??= UserSessionLocal.getInstancia();
    return _this!;
  }
  VarGlobales globales = VarGlobales();
  UserSessionLocal.getInstancia() : super();

  @override
  String? get dbname => globales.dbName;

  @override
  int? get dbversion => globales.dbVersion;

  Future<Usuario> getUsuarioSession() async {
    Database? db = await getDb();
    if (db == null) return Usuario();
    List<Map> maps = await db.rawQuery('SELECT * FROM session');
    if (maps.isNotEmpty) {
      return Usuario.fromJson(maps.first);
    } else {
      return Usuario();
    }
  }

  Future<bool> guardarUsuarioSession(Usuario user) async {
    Database? db = await getDb();
    if (db == null) return false;
    List<Map> maps = await db.query('session',
        where: 'id = ?', whereArgs: [user.id], limit: 1);
    if (maps.isEmpty) {
      int row = await db.rawInsert(
          'INSERT INTO session(id ,name, email, usernick, password, profile_photo_url) VALUES (?,?,?,?,?,?)',
          [
            user.id,
            user.name,
            user.email,
            user.usernick,
            user.password,
            user.profilePhotoUrl
          ]);
      return row != 0;
    } else {
      return false;
    }
  }

  Future<bool> cerrarSession(Usuario user) async {
    Database? db = await getDb();
    if (db == null) return false;
    // List<Map> maps_session = await db.rawQuery('SELECT * FROM session WHERE id = ?', [user.id]);
    List<Map> maps = await db.query('session',
        where: 'id = ?', whereArgs: [user.id], limit: 1);
    if (maps.isNotEmpty) {
      int row =
          await db.delete('session', where: 'id = ?', whereArgs: [user.id]);
      return row != 0;
    } else {
      return false;
    }
  }
}
