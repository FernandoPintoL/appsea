import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/http_response.dart';

mixin RequestController {
  // String url = "http://192.168.100.5/api";

  // String url = "https://seaweb-production.up.railway.app/api";

  String url = "https://sea-production-2d37.up.railway.app/api";
  Map<String, String> header = {'Content-Type': 'application/json'};
  String csrf_token = "";
  HttpResponsse httpResponsse = HttpResponsse(false, false, true, "Error!", "", [], 500);

  // ESTE SI LA USO
  Future<HttpResponsse> uploadDioUint8List(String route, Uint8List file, String filename, int id) async {
    try {
      DateTime now = DateTime.now(); // Obtener la hora actual del dispositivo
      String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'id': id,
        'file': MultipartFile.fromBytes(file, filename: filename),
        'created_at': formattedTime,
        'updated_at': formattedTime
      });
      Response response = await dio.post("$url/$route",
          data: formData,
          options: Options(
            method: "POST",
            contentType: 'multipart/form-data',
            headers: {'Content-Type': 'multipart/form-data'},
          ));
      print("respuesta: RESPONSE DATA");
      print(response.data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        httpResponsse = HttpResponsse.fromJson(response.data);
        httpResponsse.statusCode = 200;
      } else {
        httpResponsse.statusCode = response.statusCode == null ? 0 : response.statusCode!;
        httpResponsse.message = response.data.toString();
      }
      return httpResponsse;
    } on UnsupportedError catch (e) {
      httpResponsse.statusCode = 500;
      httpResponsse.message = e.toString();
      return httpResponsse;
    } on Error catch (e) {
      httpResponsse.statusCode = 500;
      httpResponsse.message = e.toString();
      return httpResponsse;
    } on Exception catch (e) {
      httpResponsse.statusCode = 500;
      httpResponsse.message = e.toString();
      return httpResponsse;
    }
  }

  //FUNCTION GET
  Future<HttpResponsse> getResponse(String route) async {
    try {
      Uri ruta = Uri.parse('$url/$route');
      http.Response response = await http.get(ruta);
      HttpResponsse httpResponsse = HttpResponsse.fromJson(convert.jsonDecode(response.body));
      return httpResponsse;
    } on Exception catch (e) {
      httpResponsse.statusCode = 500;
      httpResponsse.message = e.toString();
      return httpResponsse;
    }
  }

  // CONSULTA
  Future<HttpResponsse> consulta(String route, dynamic data) async {
    try {
      Uri ruta = Uri.parse('$url/$route');
      http.Response response =
          await http.post(ruta, headers: {'Content-Type': 'application/json'}, body: convert.jsonEncode(data));
      HttpResponsse httpResponsse = HttpResponsse.fromJson(convert.jsonDecode(response.body));
      print(httpResponsse);
      return httpResponsse;
    } on Exception catch (e) {
      httpResponsse.statusCode = 500;
      httpResponsse.message = e.toString();
      return httpResponsse;
    }
  }

  //INSERTAR UNA TUPLA
  Future<HttpResponsse> insertResponse(String route, dynamic data) async {
    try {
      DateTime now = DateTime.now(); // Obtener la hora actual del dispositivo
      String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      data['created_at'] = formattedTime;
      data['updated_at'] = formattedTime;
      http.Response response = await http.post(Uri.parse('$url/$route'),
          headers: {'Content-Type': 'application/json'}, body: convert.jsonEncode(data));
      HttpResponsse httpResponsse = HttpResponsse.fromJson(convert.jsonDecode(response.body));
      return httpResponsse;
    } on Exception catch (e) {
      httpResponsse.statusCode = 500;
      httpResponsse.message = e.toString();
      return httpResponsse;
    }
  }

  //UPDATE TUPLA
  Future<HttpResponsse> actualizarResponse(String route, dynamic data, int id) async {
    try {
      DateTime now = DateTime.now(); // Obtener la hora actual del dispositivo
      String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      data['created_at'] = formattedTime;
      data['updated_at'] = formattedTime;
      http.Response response = await http.put(Uri.parse('$url/$route/${id.toString()}'),
          headers: {'Content-Type': 'application/json;charset=utf-8'}, body: convert.jsonEncode(data));
      if (response.statusCode == 200) {
        HttpResponsse httpResponsse = HttpResponsse.fromJson(convert.jsonDecode(response.body));
        return httpResponsse;
      } else {
        httpResponsse.statusCode = response.statusCode;
        return httpResponsse;
      }
    } on Exception catch (e) {
      httpResponsse.statusCode = 500;
      httpResponsse.message = e.toString();
      return httpResponsse;
    }
  }

  //ELIMINAR UNA TUPLA
  Future<HttpResponsse> deleteResponse(String route) async {
    try {
      http.Response response =
          await http.delete(Uri.parse('$url/$route'), headers: {'Content-Type': 'application/json'});
      print(response.statusCode);
      HttpResponsse httpResponsse = HttpResponsse.fromJson(convert.jsonDecode(response.body));
      return httpResponsse;
    } on Exception catch (e) {
      httpResponsse.statusCode = 500;
      httpResponsse.message = e.toString();
      return httpResponsse;
    }
  }

  // MOSTRAR MODELO
  Future<HttpResponsse> showModel(String route) async {
    try {
      http.Response response = await http.get(Uri.parse('$url/$route'), headers: {'Content-Type': 'application/json'});
      print(response.statusCode);
      print(convert.jsonDecode(response.body));
      HttpResponsse httpResponsse = HttpResponsse.fromJson(convert.jsonDecode(response.body));
      return httpResponsse;
    } on Exception catch (e) {
      httpResponsse.statusCode = 500;
      httpResponsse.message = e.toString();
      return httpResponsse;
    }
  }
}
