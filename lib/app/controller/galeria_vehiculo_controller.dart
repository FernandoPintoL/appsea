import 'dart:typed_data';
import '../models/galeria_vehiculo_model.dart';
import '../models/http_response.dart';
import 'request_controller.dart';

class GaleriaVehiculoController with RequestController {
  String apiRoute = 'appgaleriavehiculo';

  Future<HttpResponsse> insertar(GaleriaVehiculo data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(GaleriaVehiculo data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(GaleriaVehiculo data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }

  Future<HttpResponsse> getGaleriaVehiculo(int vehiculo_id) async {
    return await consulta('$apiRoute/vehiculoid', {'vehiculo_id': vehiculo_id});
  }
  Future<HttpResponsse> dioUint8List(int id, String filename, Uint8List file) async {
    return await uploadDioUint8List('$apiRoute/uploadimage', file, filename, id);
  }
}
