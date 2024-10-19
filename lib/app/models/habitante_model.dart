import 'dart:convert' as convert;
import 'perfil_model.dart';
import 'vivienda_model.dart';

class Habitante {
  late int id, responsable_id, perfil_id, vivienda_id;
  late bool isDuenho = true, isDependiente = false;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();
  Perfil perfil = Perfil();
  Vivienda vivienda = Vivienda();

  dynamic nombreError = "", userloginError = "", emailError = "", passwordError = "";

  Habitante(
      {this.id = 0,
      this.responsable_id = 0,
      this.perfil_id = 0,
      this.vivienda_id = 0,
      this.isDuenho = true,
      this.isDependiente = false});

  // DE MI API
  factory Habitante.fromJson(Map<dynamic, dynamic> json) {
    Habitante model = Habitante(
      id: int.tryParse(json['id'].toString())!,
      perfil_id: json['perfil_id'] == null ? 0 : int.tryParse(json['perfil_id'].toString())!,
      responsable_id: json['responsable_id'] != null ? int.tryParse(json['responsable_id'].toString())! : 0,
      vivienda_id: json['vivienda_id'] != null ? int.tryParse(json['vivienda_id'].toString())! : 0,
      isDuenho: json['isDuenho'] ?? true,
      isDependiente: json['isDependiente'] ?? false,
    );
    model.creado = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now();
    model.actualizado = json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()) : DateTime.now();
    //DATOS DEL PERFIL
    model.perfil.id = json['id_perfil'] == null ? 0 : int.tryParse(json['id_perfil'].toString())!; //json['id_perfil'];
    model.perfil.nombre = json['name'] ?? '';
    model.perfil.nroDocumento = json['nroDocumento'] ?? '';
    model.perfil.celular = json['celular'] ?? '';
    model.perfil.email = json['email'] ?? '';
    //DATOS DE LA VIVIENDA
    model.vivienda.id = json['id_vivienda'] == null ? 0 : int.tryParse(json['id_vivienda'].toString())!;// json['id_vivienda'];
    model.vivienda.nroVivienda = json['nroVivienda'];
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'perfil_id': perfil_id == 0 ? '0' : perfil_id.toString(),
        'responsable_id': responsable_id == 0 ? null : responsable_id.toString(),
        'isDuenho': isDuenho,
        'isDependiente': isDependiente,
        'isMobile': true,
        'perfil': perfil.toJson(),
        'vivienda': vivienda.toJson(),
      };

  static List<Habitante> parseString(String responseBody) {
    final parsed = convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Habitante> list = parsed.map<Habitante>((json) => Habitante.fromJson(json)).toList();
    return list;
  }

  List<Habitante> parseDynamic(dynamic listData) {
    List<Habitante> lista = listData.map<Habitante>((e) => Habitante.fromJson(e)).toList();
    return lista;
  }

  String fechaCreado() {
    return '${creado.day}/${creado.month}/${creado.year}';
  }

  String horaCreado() {
    String hora = creado.hour < 10 ? '0${creado.hour}' : creado.hour.toString();
    String minuto = creado.minute < 10 ? '0${creado.minute}' : creado.minute.toString();
    return "$hora:$minuto";
  }

  String fechaActualizado() {
    return '${actualizado.day}/${actualizado.month}/${actualizado.year}';
  }

  String horaActualizado() {
    String hora = actualizado.hour < 10 ? '0${actualizado.hour}' : actualizado.hour.toString();
    String minuto = actualizado.minute < 10 ? '0${actualizado.minute}' : actualizado.minute.toString();
    return "$hora:$minuto";
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
