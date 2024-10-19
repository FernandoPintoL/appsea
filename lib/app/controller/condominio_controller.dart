import '../models/condominio_model.dart';
import '../models/http_response.dart';
import 'request_controller.dart';

class CondominioController with RequestController {
  List<Condominio> lista = [];
  String apiRoute = 'appcondominios';

  Future<HttpResponsse> insertar(Condominio data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(Condominio data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(Condominio data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }
}
