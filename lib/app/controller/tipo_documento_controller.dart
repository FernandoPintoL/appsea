import '../models/http_response.dart';
import '../models/tipo_documento_model.dart';
import 'request_controller.dart';

class TipoDocumentoController with RequestController {
  List<TipoDocumento> lista = [];
  String apiRoute = 'apptipodocumento';

  Future<HttpResponsse> insertar(TipoDocumento data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(TipoDocumento data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(TipoDocumento data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }
}
