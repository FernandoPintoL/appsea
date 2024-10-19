import 'dart:convert' as convert;

class TipoVisita {
  late int id;
  late String sigla, detalle;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  dynamic nombreError = "",
      userloginError = "",
      emailError = "",
      passwordError = "";
  TipoVisita({this.id = 0, this.sigla = '', this.detalle = ''});

  // DE MI API
  factory TipoVisita.fromJson(Map<dynamic, dynamic> json) {
    int id = 0;
    if (json['id'] != null) {
      id = int.tryParse(json['id'].toString())!;
    }
    if (json['tipo_visita_id'] != null) {
      id = int.tryParse(json['tipo_visita_id'].toString())!;
    }
    TipoVisita model = TipoVisita(
        id: id,
        sigla: json['sigla'] == null ? "" : json['sigla'].toString(),
        detalle: json['detalle'] == null ? "" : json['detalle'].toString());
    model.creado = json['created_at'] != null
        ? DateTime.parse(json['created_at'].toString())
        : DateTime.now();
    model.actualizado = json['updated_at'] != null
        ? DateTime.parse(json['updated_at'].toString())
        : DateTime.now();
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() =>
      {'id': id.toString(), 'sigla': sigla, 'detalle': detalle};

  static List<TipoVisita> parseString(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<TipoVisita> list =
        parsed.map<TipoVisita>((json) => TipoVisita.fromJson(json)).toList();
    return list;
  }

  List<TipoVisita> parseDynamic(dynamic listData) {
    List<TipoVisita> lista =
        listData.map<TipoVisita>((e) => TipoVisita.fromJson(e)).toList();
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
