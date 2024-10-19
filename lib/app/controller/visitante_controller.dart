import '../models/http_response.dart';
import '../models/visitante_model.dart';
import 'request_controller.dart';

class VisitanteController with RequestController {
  List<Visitante> lista = [];
  String apiRoute = 'appvisitante';

  Future<HttpResponsse> insertar(Visitante data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(Visitante data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> actualizarDynamic(String route, dynamic data, int id) async {
    return await actualizarResponse("$apiRoute/$route", data, id);
  }

  Future<HttpResponsse> delete(Visitante data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query, bool black_list) async {
    return await consulta('$apiRoute/query', {'query': query.toUpperCase(), 'black_list': black_list});
  }

  Future<HttpResponsse> queryStartEnd(int skip, int take) async {
    return await consulta('$apiRoute/query', {'skip': skip.toString(), 'take': take.toString()});
  }

  Future<HttpResponsse> show(int id) async {
    return await showModel('$apiRoute/$id');
  }
}
