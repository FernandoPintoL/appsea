import 'dart:convert' as convert;

import 'condominio_model.dart';
class Usuario {
  late int id;
  late String name,
      usernick,
      email,
      profilePhotoUrl,
      profilePhotoPath,
      password,
      passwordRepeat;

  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  bool terms;

  dynamic nombreError = "",
      userloginError = "",
      emailError = "",
      passwordError = "";

  Condominio condominio = Condominio();

  Usuario(
      {this.id = 0,
      this.name = '',
      this.email = '',
      this.usernick = "",
      this.profilePhotoUrl = '',
      this.profilePhotoPath = '',
      this.password = '',
      this.passwordRepeat = '',
      this.terms = false});

  // CUANDO RECIBO DE MI API
  factory Usuario.fromJson(Map<dynamic, dynamic> json) {
    Usuario model = Usuario(
        id: int.tryParse(json['id'].toString())!,
        name: json['name'].toString(),
        usernick: json['usernick'].toString(),
        email: json['email'].toString(),
        password: json['password'].toString(),
        profilePhotoUrl: json['profile_photo_url'].toString(),
        profilePhotoPath: json['profile_photo_path'].toString()
    );
    model.creado = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now();
    model.actualizado = json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()) : DateTime.now();
    if(json['condominio'] != null){
      model.condominio = Condominio.fromJson(json['condominio']);
    }
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'name': name,
        'usernick': usernick,
        'email': email,
        'password': password,
        'password_confirmation': passwordRepeat,
        'profile_photo_path': profilePhotoPath,
        'profile_photo_url': profilePhotoUrl,
        'terms': terms ? 'accepted' : ""
      };

  static List<Usuario> parseString(String responseBody) {
    final parsed =
        convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Usuario> list =
        parsed.map<Usuario>((json) => Usuario.fromJson(json)).toList();
    return list;
  }

  List<Usuario> parseDynamic(dynamic listData) {
    List<Usuario> lista =
        listData.map<Usuario>((e) => Usuario.fromJson(e)).toList();
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
