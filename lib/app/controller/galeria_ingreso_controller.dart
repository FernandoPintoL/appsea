import '../models/galeria_ingreso_model.dart';
import '../models/http_response.dart';
import 'request_controller.dart';

class GaleriaIngresoController with RequestController {
  List<GaleriaIngreso> lista = [];
  String apiRoute = 'appgaleriaingresos';

  Future<HttpResponsse> insertar(GaleriaIngreso data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(GaleriaIngreso data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(GaleriaIngreso data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }
}
