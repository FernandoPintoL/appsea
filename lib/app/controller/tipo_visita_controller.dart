import '../models/http_response.dart';
import '../models/tipo_visita_model.dart';
import 'request_controller.dart';

class TipoVisitaController with RequestController {
  List<TipoVisita> lista = [];
  String apiRoute = 'apptipovisita';

  Future<HttpResponsse> insertar(TipoVisita data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(TipoVisita data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(TipoVisita data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }
}
