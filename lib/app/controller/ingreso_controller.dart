import 'package:intl/intl.dart';
import '../models/http_response.dart';
import '../models/ingreso_model.dart';
import 'request_controller.dart';

class IngresoController with RequestController {
  List<Ingreso> lista = [];
  String apiRoute = 'appingreso';

  Future<HttpResponsse> insertar(Ingreso data) async {
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> registrarSalida(int id, String detalle) async {
    DateTime now = DateTime.now(); // Obtener la hora actual del dispositivo
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    return await actualizarResponse(
        "$apiRoute/registerSalida",
        {
          "id": id.toString(),
          "detalle_salida": detalle,
          "salida_created_at": formattedTime,
          "salida_updated_at": formattedTime
        },
        id);
  }

  Future<HttpResponsse> actualizar(Ingreso data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(Ingreso data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query, int condominio_id, bool salidas_registradas ,String created_at_start, String created_at_end, String salida_created_at_start, String salida_created_at_end, int skip, int take) async {
    dynamic data = {
      'query': query.toUpperCase(),
      'condominio_id': condominio_id,
      'salidas_registradas': salidas_registradas,
      'created_at_start' : created_at_start.isEmpty ? null : created_at_start,
      'created_at_end': created_at_end.isEmpty ? null : created_at_end,
      'salida_created_at_start' : salida_created_at_start.isEmpty ? null : salida_created_at_start,
      'salida_upadated_at_end': salida_created_at_end.isEmpty ? null : salida_created_at_end,
      'take' : take == -1 ? null : take,
      'skip': skip == -1 ? null : skip
    };
    return await consulta('$apiRoute/query', data);
  }

  Future<HttpResponsse> queryStartEnd(int skip, int take) async {
    return await consulta('$apiRoute/query', {'skip': skip.toString(), 'take': take.toString()});
  }

  Future<HttpResponsse> consultarDate(String start, String end) async {
    return await consulta('$apiRoute/queryDate', {'start': start, 'end': end});
  }
}
