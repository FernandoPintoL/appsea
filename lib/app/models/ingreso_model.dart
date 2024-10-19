import 'dart:convert' as convert;

import 'habitante_model.dart';
import 'perfil_model.dart';
import 'tipo_visita_model.dart';
import 'user_model.dart';
import 'vehiculo_model.dart';
import 'visitante_model.dart';

class Ingreso {
  late int id,
      visitante_id,

      ///FK
      residente_habitante_id,

      ///FK
      autoriza_habitante_id,

      ///FK
      ingresa_habitante_id,

      ///FK
      vehiculo_id,

      ///FK
      tipo_visita_id,

      ///FK
      user_id;

  ///FK
  late String tipo_ingreso;

  String? detalle, detalleSalida, created_at, updated_at, salida_created_at, salida_updated_at;
  DateTime creado = DateTime.now(), actualizado = DateTime.now();

  bool isAutorizado,
      isNewVehiculo = false,
      isNewVisitante = false,
      isIngresoConVehiculo = false,
      is_permitido = true,
      black_list = false;

  Visitante visitante = Visitante();

  // Vivienda vivienda = Vivienda();

  Habitante autoriza = Habitante();
  Habitante residente = Habitante();
  Habitante ingresa = Habitante();
  TipoVisita tipoVisita = TipoVisita();
  Vehiculo vehiculo = Vehiculo();
  Usuario user = Usuario();
  Perfil perfil = Perfil();

  dynamic nombreError = "", userloginError = "", emailError = "", passwordError = "";

  Ingreso(
      {this.id = 0,
      this.visitante_id = 0,
      this.residente_habitante_id = 0,
      this.autoriza_habitante_id = 0,
      this.ingresa_habitante_id = 0,
      this.vehiculo_id = 0,
      this.tipo_visita_id = 0,
      this.user_id = 0,
      this.tipo_ingreso = '',
      this.detalle = '',
      this.detalleSalida = '',
      this.created_at = "",
      this.updated_at = "",
      this.salida_created_at = "",
      this.salida_updated_at = "",
      this.isAutorizado = false,
      this.is_permitido = true,
      this.black_list = false});

  // CUANDO RECIBO DE MI API
  factory Ingreso.fromJson(Map<dynamic, dynamic> json) {
    Ingreso model = Ingreso(
      id: int.tryParse(json['id'].toString())!,
      isAutorizado: json['isAutorizado'],
      detalle: json['detalle'] == null ? "" : json['detalle'].toString(),
      detalleSalida: json['detalle_salida'] == null ? "" : json['detalle_salida'].toString(),
      tipo_ingreso: json['tipo_ingreso'].toString(),
      created_at: json['created_at'] ?? "",
      updated_at: json['updated_at'] ?? "",
      salida_created_at: json['salida_created_at'] ?? "",
      salida_updated_at: json['salida_updated_at'] ?? "",
      visitante_id: json['visitante_id'] == null ? 0 : int.tryParse(json['visitante_id'].toString())!,

      ///FK
      residente_habitante_id:
          json['residente_habitante_id'] == null ? 0 : int.tryParse(json['residente_habitante_id'].toString())!,

      ///FK
      autoriza_habitante_id:
          json['autoriza_habitante_id'] == null ? 0 : int.tryParse(json['autoriza_habitante_id'].toString())!,

      ///FK
      ingresa_habitante_id:
          json['ingresa_habitante_id'] == null ? 0 : int.tryParse(json['ingresa_habitante_id'].toString())!,

      ///FK
      vehiculo_id: json['vehiculo_id'] == null ? 0 : int.tryParse(json['vehiculo_id'].toString())!,

      ///FK
      tipo_visita_id: json['tipo_visita_id'] == null ? 0 : int.tryParse(json['tipo_visita_id'].toString())!,

      ///FK
      user_id: int.tryParse(json['user_id'].toString())!,
    );
    model.creado = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()) : DateTime.now();
    model.actualizado = json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()) : DateTime.now();

    if (json['visitante'] != null) {
      model.visitante = Visitante.fromJson(json['visitante']);
    } else {
      model.visitante.id = json['id_visitante'] == null ? 0 : int.tryParse(json['id_visitante'].toString())!; //json['id_visitante'];
      model.visitante.is_permitido = json['is_permitido'];
      model.visitante.descripition_is_no_permitido = json['descripition_is_no_permitido'] ?? "";
      model.visitante.perfil.nombre = json['name_visitante'] ?? '';
      model.visitante.perfil.nroDocumento = json['nroDocumento_visitante'] ?? '';
    }
    if (json['residente'] != null) {
      model.residente = Habitante.fromJson(json['residente']);
    } else {
      model.residente.id = json['id_residente'] == null ? 0 : int.tryParse(json['id_residente'].toString())!; //json['id_residente'];
      model.residente.perfil.nombre = json['name_residente'] ?? '';
      model.residente.perfil.nroDocumento = json['nroDocumento_residente'] ?? '';
      model.residente.vivienda.id = json['id_vivienda'] == null ? 0 : int.tryParse(json['id_vivienda'].toString())!;// json['id_vivienda'];
      model.residente.vivienda.nroVivienda = json['nroVivienda'] ?? "";
    }

    if (json['tipo_visita'] != null) {
      model.tipoVisita = TipoVisita.fromJson(json['tipo_visita']);
    } else {
      model.tipoVisita.id = json['tv_id'] ?? 0;
      model.tipoVisita.sigla = json['tv_sigla'] ?? '';
      model.tipoVisita.detalle = json['tv_detalle'] ?? '';
    }
    return model;
  }

  //CUANDO ENVIO A MI API
  Map<String, dynamic> toJson() => {
        'id': id.toString(),

        ///FK
        'visitante_id': visitante_id.toString(),

        ///FK
        'residente_habitante_id': residente_habitante_id.toString(),

        ///FK
        'autoriza_habitante_id': autoriza_habitante_id.toString(),

        ///FK
        'ingresa_habitante_id': ingresa_habitante_id.toString(),

        ///FK
        'vehiculo_id': vehiculo_id == 0 ? null : vehiculo_id.toString(),

        ///FK
        'tipo_visita_id': tipo_visita_id.toString(),

        ///FK
        'user_id': user_id.toString(),

        ///FK
        'tipo_ingreso': tipo_ingreso.isEmpty ? 'vehiculo' : tipo_ingreso,
        'detalle': detalle ?? "",
        'detalle_salida': detalleSalida ?? "",
        'isAutorizado': isAutorizado,
        'isMobile': true,
        'salida_created_at': salida_created_at,
        'salida_updated_at': salida_updated_at,
        'tipo_visita': tipoVisita.toJson(),
        'is_permitido': is_permitido,
        'black_list': black_list,
        'residente': residente.toJson(),
        'vehiculo': vehiculo.toJson(),
        'created_at': creado.toString(),
        'updated_at': actualizado.toString(),
      };

  static List<Ingreso> parseString(String responseBody) {
    final parsed = convert.jsonDecode(responseBody).cast<Map<String, dynamic>>();
    List<Ingreso> list = parsed.map<Ingreso>((json) => Ingreso.fromJson(json)).toList();
    return list;
  }

  List<Ingreso> parseDynamic(dynamic listData) {
    List<Ingreso> lista = listData.map<Ingreso>((e) => Ingreso.fromJson(e)).toList();
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
