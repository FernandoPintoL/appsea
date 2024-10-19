import 'dart:convert' as convert;
class GaleriaCondominio {
  late int id, condominio_id;
  late String photo_path,
      detalle;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  dynamic nombreError = "",
      userloginError = "",
      emailError = "",
      passwordError = "";

  GaleriaCondominio(
      {this.id = 0,
        this.condominio_id = 0,
        this.photo_path = '',
        this.detalle = ''
      });

  // DE MI API
  factory GaleriaCondominio.fromJson(Map<dynamic, dynamic> json) {
    GaleriaCondominio model = GaleriaCondominio(
        id: int.tryParse(json['id'].toString())!,
        condominio_id: int.tryParse(json['condominio_id'].toString())!,
        photo_path: json['photo_path'].toString(),
        detalle: json['detalle'].toString()
    );
    model.creado = DateTime.parse(json['created_at'].toString());
    model.actualizado = DateTime.parse(json['updated_at'].toString());
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
    'id': id.toString(),
    'condominio_id': condominio_id.toString(),
    'photo_path': photo_path,
    'detalle': detalle
  };

  static List<GaleriaCondominio> parseString(String responseBody) {
    final parsed =
    convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<GaleriaCondominio> list =
    parsed.map<GaleriaCondominio>((json) => GaleriaCondominio.fromJson(json)).toList();
    return list;
  }

  List<GaleriaCondominio> parseDynamic(dynamic listData) {
    List<GaleriaCondominio> lista =
    listData.map<GaleriaCondominio>((e) => GaleriaCondominio.fromJson(e)).toList();
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
