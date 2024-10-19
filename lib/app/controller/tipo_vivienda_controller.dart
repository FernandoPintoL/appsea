import '../models/http_response.dart';
import '../models/tipo_vivienda_model.dart';
import 'request_controller.dart';

class TipoViviendasController with RequestController {
  List<TipoVivienda> lista = [];
  String apiRoute = 'apptipovivienda';

  Future<HttpResponsse> insertar(TipoVivienda data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(TipoVivienda data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(TipoVivienda data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }
}
