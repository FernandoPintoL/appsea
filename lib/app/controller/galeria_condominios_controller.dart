import '../models/galeria_condominio_model.dart';
import '../models/http_response.dart';
import 'request_controller.dart';

class GaleriaCondominioController with RequestController {
  List<GaleriaCondominio> lista = [];
  String apiRoute = 'appgaleriacondominios';

  Future<HttpResponsse> insertar(GaleriaCondominio data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(GaleriaCondominio data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(GaleriaCondominio data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }
}
