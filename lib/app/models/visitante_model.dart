import 'dart:convert' as convert;
import 'perfil_model.dart';

class Visitante {
  late int id, perfil_id;
  DateTime creado = DateTime.now(), actualizado = DateTime.now();
  String? created_at, updated_at;
  Perfil perfil = Perfil();
  bool is_permitido = true;
  String descripition_is_no_permitido = "";

  String? _nombreError;
  String? _nroDocumentoError;

  Visitante(
      {this.id = 0,
      this.perfil_id = 0,
      this.is_permitido = true,
      this.descripition_is_no_permitido = "",
      this.created_at = "",
      this.updated_at = ""});

  // DE MI API
  factory Visitante.fromJson(Map<dynamic, dynamic> json) {
    int id = 0;
    if (json['id'] != null) {
      id = int.tryParse(json['id'].toString())!;
    }
    if (json['visitante_id'] != null) {
      id = int.tryParse(json['visitante_id'].toString())!;
    }
    Visitante model = Visitante(
      id: id,
      is_permitido: json['is_permitido'],
      descripition_is_no_permitido: json['descripition_is_no_permitido'] ?? "",
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
      perfil_id: json['perfil_id'] == null ? 0 : int.tryParse(json['perfil_id'].toString())!,
    );
    if (json['perfil'] != null) {
      model.perfil = Perfil.fromJson(json['perfil']);
    } else {
      // model.perfil = Perfil.fromJson(json);
      model.perfil.id = json['perfil_id'] == null ? 0 : int.tryParse(json['perfil_id'].toString())!; //json['perfil_id'];
      model.perfil.nombre = json['name'];
      model.perfil.nroDocumento = json['nroDocumento'] ?? "";
      model.perfil.celular = json['celular'] ?? "";
    }
    model.creado = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now();
    model.actualizado = json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()) : DateTime.now();
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'is_permitido': is_permitido,
        'descripition_is_no_permitido': descripition_is_no_permitido,
        'perfil_id': perfil_id.toString(),
        'isMobile': true,
        'perfil': perfil.toJson(),
      };

  static List<Visitante> parseString(String responseBody) {
    final parsed = convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Visitante> list = parsed.map<Visitante>((json) => Visitante.fromJson(json)).toList();
    return list;
  }

  List<Visitante> parseDynamic(dynamic listData) {
    List<Visitante> lista = listData.map<Visitante>((e) => Visitante.fromJson(e)).toList();
    return lista;
  }

  String fecha(String date) {
    if (date.isEmpty) {
      return '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
    } else {
      DateTime fecha = DateTime.parse(date);
      return '${fecha.day}-${fecha.month}-${fecha.year}';
    }
  }

  String hora(String time) {
    if (time.isEmpty) {
      return '${DateTime.now().hour}:${DateTime.now().minute}';
    } else {
      DateTime hora = DateTime.parse(time);
      return '${hora.hour}-${hora.minute}';
    }
  }

  String fechaCreado() {
    return '${creado.day}-${creado.month}-${creado.year}';
  }

  String horaCreado() {
    String hora = creado.hour < 10 ? '0${creado.hour}' : creado.hour.toString();
    String minuto = creado.minute < 10 ? '0${creado.minute}' : creado.minute.toString();
    return "$hora:$minuto";
  }

  String fechaActualizado() {
    return '${actualizado.day}-${actualizado.month}-${actualizado.year}';
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

  String? get nombreError => _nombreError;

  set nombreError(String? value) {
    _nombreError = value;
  }

  String? get nroDocumentoError => _nroDocumentoError;

  set nroDocumentoError(String? value) {
    _nroDocumentoError = value;
  }
}
