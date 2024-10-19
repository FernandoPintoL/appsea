import '../models/http_response.dart';
import '../models/user_model.dart';
import 'request_controller.dart';

class UserController with RequestController {
  List<Usuario> lista = [];
  String apiRoute = 'appusers';

  Future<HttpResponsse> insertar(Usuario user) async {
    print(user.toString());
    return await insertResponse(apiRoute, user.toJson());
  }

  Future<HttpResponsse> registerOnApi(Usuario user) async {
    print(user.toString());
    return await insertResponse("$apiRoute/registerOnApi", user.toJson());
  }

  Future<HttpResponsse> loginOnApi(String nick, String password) async {
    return await insertResponse(
        "$apiRoute/loginOnApi", {'usernick': nick, 'password': password});
  }

  Future<HttpResponsse> logout() async {
    return await insertResponse("$apiRoute/logout", {});
  }

  Future<HttpResponsse> actualizar(Usuario user) async {
    return await actualizarResponse(apiRoute, user.toJson(), user.id);
  }

  Future<HttpResponsse> delete(Usuario user) async {
    return await deleteResponse("$apiRoute/${user.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }

  Future<HttpResponsse> updatePassword(
      Map<String, dynamic> data, Usuario user) async {
    print(data.toString());
    return await actualizarResponse('$apiRoute/password', data, user.id);
  }
}
