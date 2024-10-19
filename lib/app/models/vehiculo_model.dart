import 'dart:convert' as convert;

class Vehiculo {
  late int id;
  late int visitante_id;
  late String placa, detalle, photo_path, tipo_vehiculo;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  String? _placaError;

  String? get placaError => _placaError;

  set placaError(String? value) {
    _placaError = value;
  }

  Vehiculo({
    this.id = 0,
    this.detalle = "",
    this.placa = '',
    this.visitante_id = 0,
    this.photo_path = '',
    this.tipo_vehiculo = 'automóvil',
  });

  // DE MI API
  factory Vehiculo.fromJson(Map<dynamic, dynamic> json) {
    int id = 0;
    if (json['id'] != null) {
      id = int.tryParse(json['id'].toString())!;
    }
    if (json['vehiculo_id'] != null) {
      id = int.tryParse(json['vehiculo_id'].toString())!;
    }
    Vehiculo model = Vehiculo(
      id: id,
      placa: json['placa'] == null ? "" : json['placa'].toString(),
      visitante_id: json['visitante_id'] == null ? 0 : int.tryParse(json['visitante_id'].toString())!,
      detalle: json['detalle'] == null ? "" : json['detalle'].toString(),
      photo_path: json['photo_path'] == null ? "" : json['photo_path'].toString(),
      tipo_vehiculo: json['tipo_vehiculo'] == null ? "" : json['tipo_vehiculo'].toString(),
    );
    model.creado = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now();
    model.actualizado = json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()) : DateTime.now();
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'placa': placa.isEmpty ? '' : placa,
        'visitante_id': visitante_id == 0 ? null : visitante_id,
        'detalle': detalle.isEmpty ? '' : detalle,
        'tipo_vehiculo': tipo_vehiculo.isEmpty ? 'automóvil' : tipo_vehiculo,
        'photo_path': photo_path.isEmpty ? '' : photo_path,
      };

  static List<Vehiculo> parseString(String responseBody) {
    final parsed = convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Vehiculo> list = parsed.map<Vehiculo>((json) => Vehiculo.fromJson(json)).toList();
    return list;
  }

  List<Vehiculo> parseDynamic(dynamic listData) {
    List<Vehiculo> lista = listData.map<Vehiculo>((e) => Vehiculo.fromJson(e)).toList();
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
