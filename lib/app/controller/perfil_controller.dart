import '../models/http_response.dart';
import '../models/perfil_model.dart';
import 'request_controller.dart';

class PerfilController with RequestController {
  List<Perfil> lista = [];
  String apiRoute = 'appperfil';

  Future<HttpResponsse> insertar(Perfil data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(Perfil data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(Perfil data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }

  Future<HttpResponsse> show(int id) async {
    return await showModel('$apiRoute/$id');
  }
}
