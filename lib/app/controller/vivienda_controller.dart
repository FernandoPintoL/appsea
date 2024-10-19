import '../models/http_response.dart';
import '../models/vivienda_model.dart';
import 'request_controller.dart';

class ViviendaController with RequestController {
  List<Vivienda> lista = [];
  String apiRoute = 'appvivienda';

  Future<HttpResponsse> insertar(Vivienda data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(Vivienda data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(Vivienda data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query.toUpperCase()});
  }
}
