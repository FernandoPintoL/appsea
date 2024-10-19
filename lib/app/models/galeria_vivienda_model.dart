import 'dart:convert' as convert;
class GaleriaVivienda {
  late int id, vivienda_id;
  late String photo_path,
      detalle;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  dynamic nombreError = "",
      userloginError = "",
      emailError = "",
      passwordError = "";

  GaleriaVivienda(
      {this.id = 0,
        this.vivienda_id = 0,
        this.photo_path = '',
        this.detalle = ''
      });

  // DE MI API
  factory GaleriaVivienda.fromJson(Map<dynamic, dynamic> json) {
    GaleriaVivienda model = GaleriaVivienda(
        id: int.tryParse(json['id'].toString())!,
        vivienda_id: int.tryParse(json['vivienda_id'].toString())!,
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
    'vivienda_id': vivienda_id.toString(),
    'photo_path': photo_path,
    'detalle': detalle
  };

  static List<GaleriaVivienda> parseString(String responseBody) {
    final parsed =
    convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<GaleriaVivienda> list =
    parsed.map<GaleriaVivienda>((json) => GaleriaVivienda.fromJson(json)).toList();
    return list;
  }

  List<GaleriaVivienda> parseDynamic(dynamic listData) {
    List<GaleriaVivienda> lista =
    listData.map<GaleriaVivienda>((e) => GaleriaVivienda.fromJson(e)).toList();
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
