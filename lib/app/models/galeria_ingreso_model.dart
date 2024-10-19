import 'dart:convert' as convert;
class GaleriaIngreso {
  late int id, ingreso_id;
  late String photo_path,
      detalle;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  bool isAutorizado;

  dynamic nombreError = "",
      userloginError = "",
      emailError = "",
      passwordError = "";

  GaleriaIngreso(
      {this.id = 0,
        this.ingreso_id = 0,
        this.photo_path = '',
        this.detalle = '',
        this.isAutorizado = false
      });

  // DE MI API
  factory GaleriaIngreso.fromJson(Map<dynamic, dynamic> json) {
    GaleriaIngreso model = GaleriaIngreso(
        id: int.tryParse(json['id'].toString())!,
        ingreso_id: int.tryParse(json['ingreso_id'].toString())!,
        photo_path: json['photo_path'].toString(),
        detalle: json['detalle'].toString(),
        isAutorizado: json['isAutorizado'].toString() == '1'
    );
    model.creado = DateTime.parse(json['created_at'].toString());
    model.actualizado = DateTime.parse(json['updated_at'].toString());
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
    'id': id.toString(),
    'ingreso_id': ingreso_id.toString(),
    'photo_path': photo_path,
    'detalle': detalle,
    'isAutorizado': isAutorizado
  };

  static List<GaleriaIngreso> parseString(String responseBody) {
    final parsed =
    convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<GaleriaIngreso> list =
    parsed.map<GaleriaIngreso>((json) => GaleriaIngreso.fromJson(json)).toList();
    return list;
  }

  List<GaleriaIngreso> parseDynamic(dynamic listData) {
    List<GaleriaIngreso> lista =
    listData.map<GaleriaIngreso>((e) => GaleriaIngreso.fromJson(e)).toList();
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
