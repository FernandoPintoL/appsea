import '../models/detalle_no_autorizado.dart';
import '../models/http_response.dart';
import 'request_controller.dart';

class DetalleNoAutorizadoController with RequestController {
  List<DetalleNoAutorizado> lista = [];
  String apiRoute = 'appdetallesnoautorizados';

  Future<HttpResponsse> insertar(DetalleNoAutorizado data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(DetalleNoAutorizado data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(DetalleNoAutorizado data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }
}
