import 'dart:convert' as convert;

import 'tipo_documento_model.dart';

class Perfil {
  late int id, tipo_documento_id;
  late String nombre, email, direccion, celular, nroDocumento;

  //late String estado;
  DateTime creado = DateTime.now(), actualizado = DateTime.now();
  TipoDocumento tipoDocumento = TipoDocumento();

  Perfil(
      {this.id = 0,
      this.tipo_documento_id = 0,
      this.nombre = '',
      this.email = '',
      this.direccion = '',
      this.celular = '',
      this.nroDocumento = ''});

  factory Perfil.fromJson(Map<dynamic, dynamic> json) {
    int id = 0;
    if (json['id'] != null) {
      id = int.tryParse(json['id'].toString())!;
    }
    if (json['perfil_id'] != null) {
      id = int.tryParse(json['perfil_id'].toString())!;
    }
    Perfil model = Perfil(
        id: id,
        tipo_documento_id: json['tipo_documento_id'] == null ? 0 : int.tryParse(json['tipo_documento_id'].toString())!,
        nombre: json['name'] == null ? "" : json['name'].toString(),
        email: json['email'] == null ? "" : json['email'].toString(),
        direccion: json['direccion'] == null ? "" : json['direccion'].toString(),
        celular: json['celular'] == null ? "" : json['celular'].toString(),
        nroDocumento: json['nroDocumento'] == null ? "" : json['nroDocumento'].toString());
    model.creado = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now();
    model.actualizado = json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()) : DateTime.now();
    if (json['tipoDocumento'] != null) {
      model.tipoDocumento = TipoDocumento.fromJson(json['tipoDocumento']);
    } else {
      model.tipoDocumento = TipoDocumento.fromJson(json);
    }
    return model;
  }

  /*: id = int.tryParse(json['id'].toString())!,
        nombre = json['nombre'].toString(),
        email = json['email'].toString(),
        direccion = json['direccion'].toString(),
        celular = json['celular'].toString(),
        photoUrl = json['photoUrl'].toString(),
        estado = json['estado'];*/

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': nombre.toString(),
        'email': email.isEmpty ? '' : email.toString(),
        'direccion': direccion.isEmpty ? '' : direccion.toString(),
        'celular': celular.isEmpty ? '' : celular.toString(),
        'nroDocumento': nroDocumento.isEmpty ? '' : nroDocumento.toString(),
        'tipo_documento_id': tipo_documento_id.toString()
        // 'estado': estado.toString()
      };

  static List<Perfil> parseString(String responseBody) {
    final parsed = convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Perfil> list = parsed.map<Perfil>((json) => Perfil.fromJson(json)).toList();
    return list;
  }

  List<Perfil> parseDynamic(dynamic listData) => listData.map<Perfil>((e) => Perfil.fromJson(e)).toList();

  @override
  String toString() {
    return toJson().toString();
  }
}
