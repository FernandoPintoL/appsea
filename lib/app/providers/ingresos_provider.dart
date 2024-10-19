import 'package:flutter/material.dart';
import '../../view/components/widget/dialog.dart';
import '../../view/ingresos/ingreso_main_view.dart';
import '../controller/ingreso_controller.dart';
import '../controller/tipo_visita_controller.dart';
import '../controller/user_controller.dart';
import '../controller/vehiculo_controller.dart';
import '../dblocal/condominio_local.dart';
import '../dblocal/session_local.dart';
import '../models/condominio_model.dart';
import '../models/habitante_model.dart';
import '../models/http_response.dart';
import '../models/ingreso_model.dart';
import '../models/tipo_visita_model.dart';
import '../models/user_model.dart';
import '../models/vehiculo_model.dart';
import '../models/visitante_model.dart';

class IngresosProvider extends ChangeNotifier {
  //CONTROLLERS
  IngresoController controller = IngresoController();
  VehiculoController vehiculoController = VehiculoController();
  TipoVisitaController tipoVisitaController = TipoVisitaController();
  UserController userController = UserController();
  UserSessionLocal userSessionLocal = UserSessionLocal();
  CondominioLocal condominioLocal = CondominioLocal();

  //FORM KEY DATOS DEL FORMULARIO
  GlobalKey<ScaffoldState> scaffoldkeyIngresos = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController detalleController = TextEditingController();
  TextEditingController detalleSalidaController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  TextEditingController queryVisitantesController = TextEditingController();
  TextEditingController queryVehiculoController = TextEditingController();
  TextEditingController queryResidentesController = TextEditingController();

  //MODELOS
  Ingreso _model = Ingreso();
  Habitante _residente = Habitante();
  Vehiculo _vehiculo = Vehiculo();
  TipoVisita _tipoVisita = TipoVisita();
  Usuario _user = Usuario();
  Visitante _visitante = Visitante();
  Condominio condominio = Condominio();
  List<Ingreso> _lista = [];
  List<TipoVisita> _listaTipoVisita = [];
  HttpResponsse _httpResponsse = HttpResponsse(false, false, true, "", "", [], 500);

  bool _isRegisterResidente = false;
  bool _isRegisterVisitante = false;
  bool _isRegisterVehiculo = false;
  bool _registerOnlyVehiculo = true;
  bool _registerOnlyVisitante = true;
  bool _ingresoConVehiculo = true;
  bool _isIngresoAutorizado = true;
  bool _isBlackList = false;
  bool _isRegister = true;
  bool _isLoading = false;
  bool _isRegister_formLayout = false; // MUESTRA SELECCIONAR VISITANTE/VEHICULO O FORM INGRESO
  bool _isRegisteringVehiculo = true;
  bool _salidas_registradas = false;
  String _anuncios = "";
  String _textLoading = "Cargando Listado...";
  String _textAppBar = "Gestion de Ingresos";
  int _skip = 0;
  int _take = 5;
  String _created_at_start = "";
  String _created_at_end = "";
  DateTimeRange? _selectedRange;
  String _queryDate = '';

  bool _hasMore = true;
  bool _isScrolleable = true;
  int _condominio_id = 0;

  ///CONSTRUCTOR
  IngresosProvider() {
    iniciarList();
  }

  void iniciarList() async {
    changeLoading(true, "CARGANDO INGRESOS");
    if (lista.isEmpty) {
      clearList();
      await queryListRange();
    }
    changeLoading(false, "");
  }

  Future queryListRange() async {
    if (!hasMore) return;
    // httpResponsse = await controller.queryStartEnd(skip, take);
    if (condominio.id == 0) {
      print("entrando por segunda vex listRange");
      condominio = await condominioLocal.getCondominio();
    }
    print("MI CONDOMINIO ES: $condominio");
    httpResponsse = await controller.consultar(queryController.text, condominio.id, salidas_registradas, created_at_start, created_at_end, "", "", skip, take);
    if (httpResponsse.isSuccess) {
      List<Ingreso> listado = Ingreso().parseDynamic(httpResponsse.data);
      lista.addAll(listado);
      if (listado.length < take) {
        hasMore = false;
        notifyListeners();
      } else {
        hasMore = true;
        notifyListeners();
      }
      isScrolleable = true;
      skip = skip + 5;
      notifyListeners();
    }
  }

  //carga la lista principal al modelo
  Future queryList() async {
    skip = -1;
    take = -1;
    isLoading = true;
    textLoading = "Cargando Listado";
    lista = [];
    if (condominio.id == 0) {
      print("entrando por segunda vex");
      condominio = await condominioLocal.getCondominio();
    }
    print("MI CONDOMINIO ES: $condominio");
    httpResponsse = await controller.consultar(queryController.text, condominio.id, salidas_registradas,
        created_at_start, created_at_end, "", "", skip, take);
    print(httpResponsse);
    if (httpResponsse.isSuccess) {
      lista = Ingreso().parseDynamic(httpResponsse.data);
      hasMore = false;
      isScrolleable = false;
    }
    isLoading = false;
  }

  Future queryRangeDate(String start, String end) async {
    print(start);
    print(end);
    isLoading = true;
    textLoading = "Cargando Listado";
    notifyListeners();
    httpResponsse = await controller.consultarDate(start, end);
    print(httpResponsse);
    if (httpResponsse.isSuccess) {
      clearList();
      lista = Ingreso().parseDynamic(httpResponsse.data);
      isScrolleable = false;
      hasMore = false;
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  Future cargarListTipoVisita() async {
    isLoading = true;
    textLoading = "Cargando tipo de visitas";
    notifyListeners();
    httpResponsse = await tipoVisitaController.consultar("");
    if (httpResponsse.isSuccess) {
      listaTipoVisita = TipoVisita().parseDynamic(httpResponsse.data);
      tipoVisita = listaTipoVisita.isEmpty ? TipoVisita() : listaTipoVisita.first;
      notifyListeners();
      if (!isRegister) {
        tipoVisita = listaTipoVisita.firstWhere((element) => element.id == model.tipo_visita_id);
        model.tipoVisita = tipoVisita;
        notifyListeners();
      }
    } else {
      listaTipoVisita = [];
      tipoVisita = TipoVisita();
      notifyListeners();
    }
    isLoading = false;
    textLoading = "Cargando tipo de visitas";
    notifyListeners();
  }

  Future registrarSalidaVisitante(BuildContext context, int id) async {
    changeLoading(true, "REGISTRANDO SALIDA");
    httpResponsse = await controller.registrarSalida(id, detalleSalidaController.text.toUpperCase());
    print(httpResponsse);
    if (httpResponsse.isSuccess) {
      detalleSalidaController.clear();
      clearList();
      await queryList();
    }
    changeLoading(false, "");
  }

  Future registrarNewModelo(BuildContext context) async {
    changeLoading(true, "REGISTRANDO VISITA");
    // notifyListeners();
    if (isBlackList) {
      model.black_list = true;
      model.visitante.is_permitido = false;
      model.visitante.descripition_is_no_permitido = detalleController.text.toUpperCase();
      notifyListeners();
    }
    Usuario userlocal = await userSessionLocal.getUsuarioSession();
    if (userlocal.id != 0) {
      model.user_id = userlocal.id;
    }
    model.id = 0;
    model.isIngresoConVehiculo = model.vehiculo_id > 0;
    model.tipo_visita_id = tipoVisita.id;
    model.tipo_ingreso = model.vehiculo_id > 0 ? "vehiculo" : "caminando";
    model.detalle = detalleController.text.isEmpty ? '' : detalleController.text.toUpperCase();
    model.isAutorizado = isIngresoAutorizado;
    if (!ingresoConVehiculo) {
      model.vehiculo_id = 0;
    }
    notifyListeners();
    print(model);
    httpResponsse = await controller.insertar(model);
    if (httpResponsse.isSuccess) {
      clearDetalleController();
      clearList();
      changeLoading(true, "CARGANDO VISITAS");
      await queryList();
    }
    changeLoading(false, "");
    if (!context.mounted) return;
    Navigator.pop(context);
    DialogMessage().snackBar(context, httpResponsse.message, "",
        httpResponsse.isRequest && httpResponsse.isSuccess ? Colors.green : Colors.redAccent);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const IngresoView()),
        (Route<dynamic> route) => false);
  }

  Future updateModel(BuildContext context) async {
    isLoading = true;
    textLoading = "Actualizando Datos...";
    notifyListeners();
    if (isBlackList) {
      model.black_list = true;
      model.visitante.is_permitido = false;
      model.visitante.descripition_is_no_permitido = detalleController.text.toUpperCase();
      notifyListeners();
    }
    model.detalle = detalleController.text.isEmpty ? '' : detalleController.text.toUpperCase();
    model.detalleSalida = detalleSalidaController.text;
    model.isAutorizado = isIngresoAutorizado;
    model.tipo_visita_id = tipoVisita.id;
    notifyListeners();
    httpResponsse = await controller.actualizar(model);
    isLoading = false;
    notifyListeners();
    Navigator.pop(context);
    DialogMessage().snackBar(context, httpResponsse.message, "",
        httpResponsse.isRequest && httpResponsse.isSuccess ? Colors.green : Colors.redAccent);
    queryListRange();

    ///if (!context.mounted) return;
  }

  Future cargarModelResidente(Habitante habitanteData) async {
    residente = habitanteData;
    model.residente = habitanteData;
    model.residente.perfil = habitanteData.perfil;
    model.residente.vivienda = habitanteData.vivienda;
    model.residente_habitante_id = habitanteData.id;
    model.autoriza_habitante_id = habitanteData.id;
    model.ingresa_habitante_id = 0;
    isRegisterResidente = true;

    //FUNCIONES EXTRAS
    textAppBar = "VISITANTE";
    textLoading = "Cargando Formulario".toUpperCase();

    model.visitante = Visitante(id: 0);
    visitante = Visitante(id: 0);
    isRegisterVisitante = false;

    model.vehiculo = Vehiculo(id: 0);
    vehiculo = Vehiculo(id: 0);
    isRegisterVehiculo = false;

    ingresoConVehiculo = true;
    isRegister = true;
    isIngresoAutorizado = true;
    detalleController.clear();
    notifyListeners();

    if (listaTipoVisita.isEmpty) {
      await cargarListTipoVisita();
    }
  }

  String formatStartDateTimeToString(DateTime? date) {
    if (date == null) return DateTime.now().toString();
    return '${date.year}/${date.month}/${date.day} 00:00';
  }

  String formatEndDateTimeToString(DateTime? date) {
    if (date == null) return DateTime.now().toString();
    return '${date.year}/${date.month}/${date.day} 23:59';
  }

  String formatDateTimeToString(DateTime? date) {
    if (date == null) return DateTime.now().toString();
    return '${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}';
  }

  void clearList() {
    queryController.clear();
    DateTime now = DateTime.timestamp();
    selectedRange = DateTimeRange(start: now, end: now);
    created_at_start = formatStartDateTimeToString(now);
    created_at_end = formatEndDateTimeToString(now);
    queryDate = '$created_at_start / $created_at_end';
    salidas_registradas = false;
    skip = 0;
    take = 5;
    hasMore = true;
    isScrolleable = true;
    lista = [];
  }

  void changeLoading(bool value, String text) {
    isLoading = value;
    textLoading = text;
    notifyListeners();
  }

  void deleteModelResidente() {
    residente = Habitante();
    model.residente = Habitante();
    model.residente_habitante_id = 0;
    isRegisterResidente = false;
    notifyListeners();
  }

  void deleteModelVisitante() {
    visitante = Visitante();
    model.visitante = Visitante();
    model.visitante_id = 0;
    isRegisterVisitante = false;
    notifyListeners();
  }

  void deleteModelVehiculo() {
    vehiculo = Vehiculo();
    model.vehiculo_id = 0;
    model.vehiculo = Vehiculo();
    isRegisterVehiculo = false;
    notifyListeners();
  }

  void cargarModelVisitante(Visitante visitanteData) {
    isRegisterVisitante = true;
    model.visitante_id = visitanteData.id;
    model.visitante = visitanteData;
    visitante = visitanteData;
    notifyListeners();
    TipoVisita tipo;
    if (visitanteData.is_permitido) {
      isIngresoAutorizado = true;
      tipo = listaTipoVisita.firstWhere((e) => e.id == 1); //VISITA
      detalleController.clear();
    } else {
      isIngresoAutorizado = false;
      tipo = listaTipoVisita.firstWhere((e) => e.id == 4); // NO AUTORIZADO
      detalleController.text = "INGRESO NO PERMITIDO EL VISITANTE SE ENCUENTRA EN LISTA NEGRA".toUpperCase();
    }
    tipoVisita = tipo;
    model.tipoVisita = tipo;
  }

  void cargarModelVehiculo(Vehiculo vehiculoData) {
    isRegisterVehiculo = true;
    model.vehiculo_id = vehiculoData.id;
    model.vehiculo = vehiculoData;
    vehiculo = vehiculoData;
    notifyListeners();
  }

  void clearDetalleController() {
    detalleController.clear();
    notifyListeners();
  }

  void clearController() {
    detalleController.clear();
    queryResidentesController.clear();
    queryVisitantesController.clear();
    queryVehiculoController.clear();
    ingresoConVehiculo = true;
    isIngresoAutorizado = true;
    notifyListeners();
  }

  void setModel(Ingreso data) {
    print(data.toString());
    isLoading = true;
    textLoading = "Cargando datos del modelo";
    model = data;
    ingresoConVehiculo = data.vehiculo_id != 0;
    isIngresoAutorizado = data.isAutorizado;
    model.detalle = data.detalle;
    model.isAutorizado = data.isAutorizado;
    detalleSalidaController.text = (data.detalleSalida == null ? "" : data.detalleSalida)!;
    detalleController.text = (data.detalle == null ? "" : data.detalle)!;
    notifyListeners();
    //cargando residente
    cargarModelResidente(data.residente);
    //cargando visitante
    cargarModelVisitante(model.visitante);

    if (model.vehiculo_id != 0) {
      model.vehiculo_id = data.vehiculo_id;
      model.vehiculo = data.vehiculo;
      vehiculo = data.vehiculo;
      notifyListeners();
    }
    cargarListTipoVisita();
  }

  void cargarFormularioRegister() {
    isLoading = true;
    isRegister = true;
    textLoading = "Cargando Formulario para Registrar";
    // textCreateUpdateAppBar = "Registrar nueva información";
    clearController();
    cargarListTipoVisita();
    textLoading = "";
    isLoading = false;
    notifyListeners();
  }

  void cargarFormularioUpdate() {
    isLoading = true;
    isRegister = false;
    textLoading = "Cargando Formulario para Actualizar";
    // textCreateUpdateAppBar = "Actualizar Información";
    notifyListeners();
    cargarListTipoVisita();
    isLoading = false;
    notifyListeners();
  }

  Ingreso get model => _model;

  set model(Ingreso value) {
    _model = value;
    notifyListeners();
  }

  bool get isRegister => _isRegister;

  set isRegister(bool value) {
    _isRegister = value;
    notifyListeners();
  }

  Habitante get residente => _residente;

  set residente(Habitante value) {
    _residente = value;
    notifyListeners();
  }

  Vehiculo get vehiculo => _vehiculo;

  set vehiculo(Vehiculo value) {
    _vehiculo = value;
    notifyListeners();
  }

  TipoVisita get tipoVisita => _tipoVisita;

  set tipoVisita(TipoVisita value) {
    _tipoVisita = value;
    notifyListeners();
  }

  Usuario get user => _user;

  set user(Usuario value) {
    _user = value;
    notifyListeners();
  }

  Visitante get visitante => _visitante;

  set visitante(Visitante value) {
    _visitante = value;
    notifyListeners();
  }

  List<Ingreso> get lista => _lista;

  set lista(List<Ingreso> value) {
    _lista = value;
    notifyListeners();
  }

  List<TipoVisita> get listaTipoVisita => _listaTipoVisita;

  set listaTipoVisita(List<TipoVisita> value) {
    _listaTipoVisita = value;
    notifyListeners();
  }

  HttpResponsse get httpResponsse => _httpResponsse;

  set httpResponsse(HttpResponsse value) {
    _httpResponsse = value;
    notifyListeners();
  }

  bool get isRegisterResidente => _isRegisterResidente;

  set isRegisterResidente(bool value) {
    _isRegisterResidente = value;
    notifyListeners();
  }

  bool get isRegisterVisitante => _isRegisterVisitante;

  set isRegisterVisitante(bool value) {
    _isRegisterVisitante = value;
    notifyListeners();
  }

  bool get isRegisterVehiculo => _isRegisterVehiculo;

  set isRegisterVehiculo(bool value) {
    _isRegisterVehiculo = value;
    notifyListeners();
  }

  bool get registerOnlyVehiculo => _registerOnlyVehiculo;

  set registerOnlyVehiculo(bool value) {
    _registerOnlyVehiculo = value;
    notifyListeners();
  }

  bool get registerOnlyVisitante => _registerOnlyVisitante;

  set registerOnlyVisitante(bool value) {
    _registerOnlyVisitante = value;
    notifyListeners();
  }

  bool get ingresoConVehiculo => _ingresoConVehiculo;

  set ingresoConVehiculo(bool value) {
    _ingresoConVehiculo = value;
    notifyListeners();
  }

  bool get isIngresoAutorizado => _isIngresoAutorizado;

  set isIngresoAutorizado(bool value) {
    _isIngresoAutorizado = value;
    notifyListeners();
  }

  bool get isBlackList => _isBlackList;

  set isBlackList(bool value) {
    _isBlackList = value;
    notifyListeners();
  }

  String get anuncios => _anuncios;

  set anuncios(String value) {
    _anuncios = value;
    notifyListeners();
  }

  int get skip => _skip;

  set skip(int value) {
    _skip = value;
    notifyListeners();
  }

  int get take => _take;

  set take(int value) {
    _take = value;
    notifyListeners();
  }

  bool get hasMore => _hasMore;

  set hasMore(bool value) {
    _hasMore = value;
    notifyListeners();
  }

  bool get isScrolleable => _isScrolleable;

  set isScrolleable(bool value) {
    _isScrolleable = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String get textLoading => _textLoading;

  set textLoading(String value) {
    _textLoading = value;
    notifyListeners();
  }

  String get textAppBar => _textAppBar;

  set textAppBar(String value) {
    _textAppBar = value;
    notifyListeners();
  }

  String get created_at_end => _created_at_end;

  set created_at_end(String value) {
    _created_at_end = value;
    notifyListeners();
  }

  DateTimeRange? get selectedRange => _selectedRange;

  set selectedRange(DateTimeRange? value) {
    _selectedRange = value;
    notifyListeners();
  }

  bool get salidas_registradas => _salidas_registradas;

  set salidas_registradas(bool value) {
    _salidas_registradas = value;
    notifyListeners();
  }

  bool get isRegisteringVehiculo => _isRegisteringVehiculo;

  set isRegisteringVehiculo(bool value) {
    _isRegisteringVehiculo = value;
    notifyListeners();
  }

  bool get isRegister_formLayout => _isRegister_formLayout;

  set isRegister_formLayout(bool value) {
    _isRegister_formLayout = value;
    notifyListeners();
  }

  String get queryDate => _queryDate;

  set queryDate(String value) {
    _queryDate = value;
    notifyListeners();
  }

  String get created_at_start => _created_at_start;

  set created_at_start(String value) {
    _created_at_start = value;
    notifyListeners();
  }

  int get condominio_id => _condominio_id;

  set condominio_id(int value) {
    _condominio_id = value;
    notifyListeners();
  }
}
