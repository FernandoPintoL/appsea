import 'dart:convert' as convert;
class DetalleNoAutorizado {
  late int id, ingreso_id;
  late String detalle_no_autorizado;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  dynamic nombreError = "",
      userloginError = "",
      emailError = "",
      passwordError = "";

  DetalleNoAutorizado(
      {this.id = 0,
        this.detalle_no_autorizado = ''
      });

  // DE MI API
  factory DetalleNoAutorizado.fromJson(Map<dynamic, dynamic> json) {
    DetalleNoAutorizado model = DetalleNoAutorizado(
        id: int.tryParse(json['id'].toString())!,
        detalle_no_autorizado: json['detalle_no_autorizado'].toString()
    );
    model.creado = DateTime.parse(json['created_at'].toString());
    model.actualizado = DateTime.parse(json['updated_at'].toString());
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
    'id': id.toString(),
    'detalle_no_autorizado': detalle_no_autorizado
  };

  static List<DetalleNoAutorizado> parseString(String responseBody) {
    final parsed =
    convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<DetalleNoAutorizado> list =
    parsed.map<DetalleNoAutorizado>((json) => DetalleNoAutorizado.fromJson(json)).toList();
    return list;
  }

  List<DetalleNoAutorizado> parseDynamic(dynamic listData) {
    List<DetalleNoAutorizado> lista =
    listData.map<DetalleNoAutorizado>((e) => DetalleNoAutorizado.fromJson(e)).toList();
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
