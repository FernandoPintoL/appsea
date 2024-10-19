import 'dart:convert' as convert;

import 'condominio_model.dart';
import 'tipo_vivienda_model.dart';

class Vivienda {
  late int id, nroEspacios, tipo_vivienda_id, condominio_id;
  late String detalle, nroVivienda;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  TipoVivienda tipoVivienda = TipoVivienda();
  Condominio condominio = Condominio();

  dynamic nombreError = "",
      userloginError = "",
      emailError = "",
      passwordError = "";

  Vivienda({
    this.id = 0,
    this.detalle = '',
    this.nroVivienda = '',
    this.nroEspacios = 0,
    this.tipo_vivienda_id = 0,
    this.condominio_id = 0,
  });

  // CUANDO RECIBO DE MI API
  factory Vivienda.fromJson(Map<dynamic, dynamic> json) {
    int id = 0;
    if (json['id'] != null) {
      id = int.tryParse(json['id'].toString())!;
    }
    if (json['vivienda_id'] != null) {
      id = int.tryParse(json['vivienda_id'].toString())!;
    }
    Vivienda model = Vivienda(
        id: id,
        tipo_vivienda_id: json['tipo_vivienda_id'] != null
            ? int.tryParse(json['tipo_vivienda_id'].toString())!
            : 0,
        condominio_id: json['condominio_id'] != null
            ? int.tryParse(json['condominio_id'].toString())!
            : 0,
        nroEspacios: json['nroEspacios'] != null
            ? int.tryParse(json['nroEspacios'].toString())!
            : 0,
        detalle:json['detalle'] == null ? "" : json['detalle'].toString(),
        nroVivienda: json['nroVivienda'] == null ? "" : json['nroVivienda'].toString());
    model.creado = json['created_at'] != null
        ? DateTime.parse(json['created_at'].toString())
        : DateTime.now();
    model.actualizado = json['updated_at'] != null
        ? DateTime.parse(json['updated_at'].toString())
        : DateTime.now();
    if (json['condominio'] != null) {
      model.condominio = Condominio.fromJson(json['condominio']);
    }
    if (json['tipoVivienda'] != null) {
      model.tipoVivienda = TipoVivienda.fromJson(json['tipoVivienda']);
    }
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'nroVivienda': nroVivienda,
        'detalle': detalle,
        'nroEspacios': nroEspacios.toString(),
        'tipo_vivienda_id': tipoVivienda.id.toString(),
        'condominio_id': condominio.id.toString(),
        'tipoVivienda': tipoVivienda.toJson(),
        'condominio': condominio.toJson()
      };

  static List<Vivienda> parseString(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Vivienda> list =
        parsed.map<Vivienda>((json) => Vivienda.fromJson(json)).toList();
    return list;
  }

  List<Vivienda> parseDynamic(dynamic listData) {
    List<Vivienda> lista =
        listData.map<Vivienda>((e) => Vivienda.fromJson(e)).toList();
    return lista;
  }

  String fechaCreado() {
    return '${creado.day}/${creado.month}/${creado.year}';
  }

  String horaCreado() {
    String hora = creado.hour < 10 ? '0${creado.hour}' : creado.hour.toString();
    String minuto =
        creado.minute < 10 ? '0${creado.minute}' : creado.minute.toString();
    return "$hora:$minuto";
  }

  String fechaActualizado() {
    return '${actualizado.day}/${actualizado.month}/${actualizado.year}';
  }

  String horaActualizado() {
    String hora = actualizado.hour < 10
        ? '0${actualizado.hour}'
        : actualizado.hour.toString();
    String minuto = actualizado.minute < 10
        ? '0${actualizado.minute}'
        : actualizado.minute.toString();
    return "$hora:$minuto";
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
