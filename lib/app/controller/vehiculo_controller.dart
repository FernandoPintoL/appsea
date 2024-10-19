import '../models/http_response.dart';
import '../models/vehiculo_model.dart';
import 'request_controller.dart';

class VehiculoController with RequestController {
  List<Vehiculo> lista = [];
  String apiRoute = 'appvehiculo';

  Future<HttpResponsse> insertar(Vehiculo data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(Vehiculo data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(Vehiculo data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query.toUpperCase()});
  }

  Future<HttpResponsse> queryStartEnd(int skip, int take) async {
    return await consulta('$apiRoute/query', {'skip': skip.toString(), 'take': take.toString()});
  }

  Future<HttpResponsse> consultarId(String query) async {
    return await consulta('$apiRoute/queryId', {'query': query});
  }
}
