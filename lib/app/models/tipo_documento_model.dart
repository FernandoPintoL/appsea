import 'dart:convert' as convert;

class TipoDocumento {
  late int id;
  late String sigla, detalle;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  dynamic nombreError = "",
      userloginError = "",
      emailError = "",
      passwordError = "";

  TipoDocumento({this.id = 0, this.sigla = '', this.detalle = ''});

  // DE MI API
  factory TipoDocumento.fromJson(Map<dynamic, dynamic> json) {
    int id = 0;
    if (json['id'] != null) {
      id = int.tryParse(json['id'].toString())!;
    }
    if (json['tipo_documento_id'] != null) {
      id = int.tryParse(json['tipo_documento_id'].toString())!;
    }
    TipoDocumento model = TipoDocumento(
        id: id,
        sigla: json['sigla'] == null ? "" : json['sigla'].toString(),
        detalle: json['detalle'] == null ? "" : json['detalle'].toString());
    model.creado = json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at'].toString());
    model.actualizado = json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at'].toString());
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<dynamic, dynamic> toJson() =>
      {'id': id.toString(), 'sigla': sigla, 'detalle': detalle};

  static List<TipoDocumento> parseString(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<TipoDocumento> list = parsed
        .map<TipoDocumento>((json) => TipoDocumento.fromJson(json))
        .toList();
    return list;
  }

  List<TipoDocumento> parseDynamic(dynamic listData) {
    List<TipoDocumento> lista =
        listData.map<TipoDocumento>((e) => TipoDocumento.fromJson(e)).toList();
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
