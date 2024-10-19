import 'package:flutter/material.dart';
import 'package:sea/app/models/condominio_model.dart';
import '../controller/habitante_controller.dart';
import '../dblocal/condominio_local.dart';
import '../models/habitante_model.dart';
import '../models/http_response.dart';

class ResidentesProvider extends ChangeNotifier {
  HabitanteController controller = HabitanteController();
  GlobalKey<ScaffoldState> scaffoldkeyResidentes = GlobalKey<ScaffoldState>();
  TextEditingController queryController = TextEditingController();

  CondominioLocal condominioLocal = CondominioLocal();

  Habitante _model = Habitante();
  Condominio condominio = Condominio();

  List<Habitante> _lista = [];
  HttpResponsse _httpResponsse = HttpResponsse(false, false, true, "", "", [], 500);


  //DATOS DE LAS VISTAS
  String _textAppBar = "CONTROL RESIDENTE";
  String _textLoading = "CARGANDO LISTADO";
  bool _isRegister = true;
  int _take = 10;
  bool _isLoading = false;
  int _skip = 0;
  bool _hasMore = true;
  bool _isScrolleable = true;

  ///CONSTRUCTOR
  ResidentesProvider() {
    /*if (lista.isEmpty) {
      changeLoading(true, "CARGANDO RESIDENTES");
      queryListRange();
      changeLoading(false, "");
    }*/
  }

  bool get isRegister => _isRegister;

  int get take => _take;

  bool get isLoading => _isLoading;

  String get textAppBar => _textAppBar;

  String get textLoading => _textLoading;

  int get skip => _skip;

  bool get hasMore => _hasMore;

  bool get isScrolleable => _isScrolleable;

  List<Habitante> get lista => _lista;

  HttpResponsse get httpResponsse => _httpResponsse;

  Habitante get model => _model;

  set model(Habitante value) {
    _model = value;
    notifyListeners();
  }

  set textLoading(String value) {
    _textLoading = value;
    notifyListeners();
  }

  set skip(int value) {
    _skip = value;
    notifyListeners();
  }

  set hasMore(bool value) {
    _hasMore = value;
    notifyListeners();
  }

  set isScrolleable(bool value) {
    _isScrolleable = value;
    notifyListeners();
  }

  set isRegister(bool value) {
    _isRegister = value;
    notifyListeners();
  }

  set take(int value) {
    _take = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set textAppBar(String value) {
    _textAppBar = value;
    notifyListeners();
  }

  set lista(List<Habitante> value) {
    _lista = value;
    notifyListeners();
  }

  set httpResponsse(HttpResponsse value) {
    _httpResponsse = value;
    notifyListeners();
  }

  void clearList() {
    queryController.clear();
    skip = 0;
    take = 10;
    hasMore = true;
    isScrolleable = true;
    lista = [];
    notifyListeners();
  }

  void changeLoading(bool value, String text) {
    isLoading = value;
    textLoading = text;
    notifyListeners();
  }

  Future queryList() async {
    // if(query.isEmpty) return;
    changeLoading(true, "BUSCANDO RESIDENTES");
    skip = -1;
    take = -1;
    lista = [];
    if (condominio.id == 0) {
      condominio = await condominioLocal.getCondominio();
    }
    httpResponsse = await controller.consultar(queryController.text, condominio.id, skip, take);
    if (httpResponsse.isSuccess) {
      lista = Habitante().parseDynamic(httpResponsse.data);
      isScrolleable = false;
      hasMore = false;
    }
    changeLoading(false, "");
  }

  Future queryListRange() async {
    if (!hasMore) return;
    if (condominio.id == 0) {
      condominio = await condominioLocal.getCondominio();
    }
    httpResponsse = await controller.consultar(queryController.text, condominio.id, skip, take);
    if (httpResponsse.isSuccess) {
      List<Habitante> listado = Habitante().parseDynamic(httpResponsse.data);
      lista.addAll(listado);
      if (listado.length < take) {
        hasMore = false;
        notifyListeners();
      } else {
        hasMore = true;
        notifyListeners();
      }
      isScrolleable = true;
      skip = skip + 10;
      notifyListeners();
    }
  }
}
