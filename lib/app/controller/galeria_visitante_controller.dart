import 'dart:typed_data';
import '../models/galeria_visitante_model.dart';
import '../models/http_response.dart';
import 'request_controller.dart';

class GaleriaVisitanteController with RequestController {
  String apiRoute = 'appgaleriavisitante';

  Future<HttpResponsse> insertar(GaleriaVisitante data) async {
    print(data.toString());
    return await insertResponse(apiRoute, data.toJson());
  }

  Future<HttpResponsse> actualizar(GaleriaVisitante data) async {
    return await actualizarResponse(apiRoute, data.toJson(), data.id);
  }

  Future<HttpResponsse> delete(GaleriaVisitante data) async {
    return await deleteResponse("$apiRoute/${data.id.toString()}");
  }

  Future<HttpResponsse> consultar(String query) async {
    return await consulta('$apiRoute/query', {'query': query});
  }

  Future<HttpResponsse> getGaleriaVisitante(int visitante_id) async {
    return await consulta(
        '$apiRoute/visitanteid', {'visitante_id': visitante_id});
  }

  /*Future<HttpResponsse> cargarXFile(int id, XFile file) async {
    return await uploadXFileDio('$apiRoute/uploadimage', file, id);
  }

  Future<HttpResponsse> uploadUint8List(int id, Uint8List file) async {
    return await subirfileUint8list('$apiRoute/uploadimage', file, id);
  }*/

  Future<HttpResponsse> dioUint8List(int id, String filename, Uint8List file) async {
    return await uploadDioUint8List('$apiRoute/uploadimage', file, filename, id);
  }
}
