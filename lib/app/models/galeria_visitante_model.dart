import 'dart:convert' as convert;

class GaleriaVisitante {
  late int id, visitante_id;
  late String photo_path, detalle;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  dynamic nombreError = "",
      userloginError = "",
      emailError = "",
      passwordError = "";

  GaleriaVisitante(
      {this.id = 0,
      this.visitante_id = 0,
      this.photo_path = '',
      this.detalle = ''});

  // DE MI API
  factory GaleriaVisitante.fromJson(Map<dynamic, dynamic> json) {
    GaleriaVisitante model = GaleriaVisitante(
        id: int.tryParse(json['id'].toString())!,
        visitante_id: json['visitante_id'] == null ? 0 : int.tryParse(json['visitante_id'].toString())!,
        photo_path: json['photo_path'] == null ? '' : json['photo_path'].toString(),
        detalle: json['detalle'] == null ? '' : json['detalle'].toString());
    model.creado = json['created_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['created_at'].toString());
    model.actualizado = json['updated_at'] == null
        ? DateTime.now()
        : DateTime.parse(json['updated_at'].toString());
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'visitante_id': visitante_id == 0 ? '0': visitante_id.toString(),
        'photo_path': photo_path.isEmpty ? '' : photo_path,
        'detalle': detalle.isEmpty ? '' : detalle
      };

  static List<GaleriaVisitante> parseString(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<GaleriaVisitante> list = parsed
        .map<GaleriaVisitante>((json) => GaleriaVisitante.fromJson(json))
        .toList();
    return list;
  }

  List<GaleriaVisitante> parseDynamic(dynamic listData) {
    List<GaleriaVisitante> lista = listData
        .map<GaleriaVisitante>((e) => GaleriaVisitante.fromJson(e))
        .toList();
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
