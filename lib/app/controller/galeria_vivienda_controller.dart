import '../models/galeria_vivienda_model.dart';
import '../models/http_response.dart';
import 'request_controller.dart';

class GaleriaViviendaController with RequestController {
  List<GaleriaVivienda> lista = [];
  String apiRoute = 'appgaleriaviviendas';

  Future<HttpResponsse> insertar(GaleriaVivienda data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(GaleriaVivienda data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(GaleriaVivienda data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }
}
