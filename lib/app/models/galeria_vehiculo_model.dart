import 'dart:convert' as convert;

class GaleriaVehiculo {
  late int id, vehiculo_id;
  late String photo_path, detalle;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  dynamic nombreError = "",
      userloginError = "",
      emailError = "",
      passwordError = "";

  GaleriaVehiculo(
      {this.id = 0,
      this.vehiculo_id = 0,
      this.photo_path = '',
      this.detalle = ''});

  // DE MI API
  factory GaleriaVehiculo.fromJson(Map<dynamic, dynamic> json) {
    GaleriaVehiculo model = GaleriaVehiculo(
        id: int.tryParse(json['id'].toString())!,
        vehiculo_id: json['vehiculo_id'] == null ? 0 : int.tryParse(json['vehiculo_id'].toString())!,
        photo_path: json['photo_path'] == null ? '' : json['photo_path'].toString(),
        detalle: json['detalle'] == null ? '' : json['detalle'].toString());
    model.creado = json['created_at'] == null ? DateTime.now() : DateTime.parse(json['created_at'].toString());
    model.actualizado = json['updated_at'] == null ? DateTime.now() : DateTime.parse(json['updated_at'].toString());
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'vehiculo_id': vehiculo_id == 0 ? '0' : vehiculo_id.toString(),
        'photo_path': photo_path.isEmpty ? '' : photo_path,
        'detalle': detalle.isEmpty ? '' : detalle
      };

  static List<GaleriaVehiculo> parseString(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<GaleriaVehiculo> list = parsed
        .map<GaleriaVehiculo>((json) => GaleriaVehiculo.fromJson(json))
        .toList();
    return list;
  }

  List<GaleriaVehiculo> parseDynamic(dynamic listData) {
    List<GaleriaVehiculo> lista = listData
        .map<GaleriaVehiculo>((e) => GaleriaVehiculo.fromJson(e))
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
