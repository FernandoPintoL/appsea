import 'dart:convert' as convert;

class Condominio {
  late int id, cantidad_viviendas, perfil_id, user_id;
  late String propietario, razonSocial, nit;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  dynamic nombreError = "", userloginError = "", emailError = "", passwordError = "";

  Condominio(
      {this.id = 0,
      this.propietario = '',
      this.razonSocial = '',
      this.nit = '',
      this.cantidad_viviendas = 0,
      this.perfil_id = 0,
      this.user_id = 0});

  // CUANDO RECIBO DE MI API
  factory Condominio.fromJson(Map<dynamic, dynamic> json) {
    Condominio model = Condominio(
      id: int.tryParse(json['id'].toString())!,
      cantidad_viviendas: json['cantidad_viviendas'] == null ? 0 : int.tryParse(json['cantidad_viviendas'].toString())!,
      perfil_id: int.tryParse(json['perfil_id'].toString())!,
      user_id: int.tryParse(json['user_id'].toString())!,
      propietario: json['propietario'] == null ? '' : json['propietario'].toString(),
      razonSocial: json['razonSocial'] == null ? '' : json['razonSocial'].toString(),
      nit: json['nit'] == null ? '' : json['nit'].toString(),
    );
    model.creado = json['created_at'] == null ? DateTime.now() : DateTime.parse(json['created_at'].toString());
    model.actualizado = json['updated_at'] == null ? DateTime.now() : DateTime.parse(json['updated_at'].toString());
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'propietario': propietario.isEmpty ? '' : propietario,
        'razonSocial': razonSocial.isEmpty ? '' : razonSocial,
        'nit': nit.isEmpty ? '' : nit,
        'perfil_id': perfil_id == 0 ? '0' : perfil_id.toString(),
        'cantidad_viviendas': cantidad_viviendas == 0 ? '0' : cantidad_viviendas.toString(),
        'user_id' : user_id.toString()
      };

  static List<Condominio> pasrseString(String responseBody) {
    final parsed = convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Condominio> list = parsed.map<Condominio>((json) => Condominio.fromJson(json)).toList();
    return list;
  }

  List<Condominio> parseDynamic(dynamic listData) {
    List<Condominio> lista = listData.map<Condominio>((e) => Condominio.fromJson(e)).toList();
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
