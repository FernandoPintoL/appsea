import '../models/habitante_model.dart';
import '../models/http_response.dart';
import 'request_controller.dart';

class HabitanteController with RequestController {
  List<Habitante> lista = [];
  String apiRoute = 'apphabitante';

  Future<HttpResponsse> insertar(Habitante data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(Habitante data) async {
    print("controller actualizacion");
    print(data.toString());
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(Habitante data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query, int condominio_id, int skip, int take) async {
    dynamic data = {
      'query': query.toUpperCase(),
      'condominio_id': condominio_id,
      'take' : take == -1 ? null : take,
      'skip': skip == -1 ? null : skip
    };
    print(data);
    return await consulta('$apiRoute/query', data);
  }

  Future<HttpResponsse> queryStartEnd(int skip, int take) async {
    return await consulta('$apiRoute/query', {'skip': skip.toString(), 'take': take.toString()});
  }

  Future<HttpResponsse> show(int id) async {
    return await showModel('$apiRoute/$id');
  }

  Future<HttpResponsse> getDuenhoVivienda(int idvivienda) async {
    return await showModel('$apiRoute/vivienda/$idvivienda');
  }

  Future<HttpResponsse> getResidente(int idResidente) async {
    return await showModel('$apiRoute/residente/$idResidente');
  }
}
