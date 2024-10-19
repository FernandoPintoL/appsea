import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sea/app/controller/galeria_vehiculo_controller.dart';
import '../../view/components/widget/dialog.dart';
import '../controller/vehiculo_controller.dart';
import '../models/galeria_vehiculo_model.dart';
import '../models/http_response.dart';
import '../models/vehiculo_model.dart';
import 'package:path/path.dart' as path;

class VehiculoProvider extends ChangeNotifier {
  VehiculoController controller = VehiculoController();
  GaleriaVehiculoController controllerGaleriaVehiculo = GaleriaVehiculoController();

  //FORM KEY
  GlobalKey<ScaffoldState> scaffoldkeyVehiculos = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController placaController = TextEditingController();
  TextEditingController detalleController = TextEditingController();
  TextEditingController selectVehiculoController = TextEditingController();
  TextEditingController queryController = TextEditingController();

  //MODELOS
  Vehiculo _model = Vehiculo();

  //LISTAS
  List<Vehiculo> _lista = [];
  List<GaleriaVehiculo> _listImagenes = [];
  List<String> _tipoVehiculos = ['automóvil', 'motocicleta', 'camión', 'bicicleta', 'otro'];

  Uint8List? _image;
  File? _selectedImage;
  XFile? _returnImage;
  String? _counterSearch;

  String? get counterSearch => _counterSearch;

  set counterSearch(String? value) {
    _counterSearch = value;
    notifyListeners();
  }

  Uint8List? get image => _image;

  set image(Uint8List? value) {
    _image = value;
    notifyListeners();
  }

  String _tipoVehiculo = "automóvil";

  //CONTROLLERS
  HttpResponsse _httpResponsse = HttpResponsse(false, false, true, "", "", [], 500);

  bool _isRegister = true;
  bool _isLoading = false;
  bool _isLoadingSelect = false;
  bool _isRegisteringVehiculo = true;
  bool _isLoadingGaleria = false;

  bool get isLoadingGaleria => _isLoadingGaleria;

  set isLoadingGaleria(bool value) {
    _isLoadingGaleria = value;
    notifyListeners();
  }

  void changeIsRegisteringVehiculo(){
    isRegisteringVehiculo = !isRegisteringVehiculo;
  }

  bool get isRegisteringVehiculo => _isRegisteringVehiculo;

  set isRegisteringVehiculo(bool value) {
    _isRegisteringVehiculo = value;
    notifyListeners();
  }

  bool _mostrarTabla = false;

  void changeMostrarTabla(){
    mostrarTabla = !mostrarTabla;
  }

  bool get mostrarTabla => _mostrarTabla;

  set mostrarTabla(bool value) {
    _mostrarTabla = value;
    notifyListeners();
  }

  bool get isLoadingSelect => _isLoadingSelect;

  set isLoadingSelect(bool value) {
    _isLoadingSelect = value;
    notifyListeners();
  }

  String _textLoading = "Cargando Listado...";
  String _textLoadingShowModal = "";

  String get textLoadingShowModal => _textLoadingShowModal;

  set textLoadingShowModal(String value) {
    _textLoadingShowModal = value;
    notifyListeners();
  }

  String _textCreateUpdateAppBar = "Registrar nueva información";
  String _textAppBar = "Gestión de Vehiculos";

  int _skip = 0;
  int _take = 5;
  bool _hasMore = true;
  bool _isScrolleable = true;

  ///CONSTRUCTOR
  VehiculoProvider() {
    /*if (lista.isEmpty) {
      queryListRange();
    }*/
  }

  Future registrarModelo(BuildContext context, int model_id) async {
    textLoadingShowModal = "REGISTRANDO VEHICULO".toUpperCase();
    changeLoading(true, "Registrando vehiculo".toUpperCase());
    cargarDataFormModel();
    model.visitante_id = model_id;
    httpResponsse = await controller.insertar(model);
    print(httpResponsse);
    if (!context.mounted) return;
    DialogMessage().snackBar(
        context,
        httpResponsse.message.toString(),
        "",
        httpResponsse.isSuccess
            ? Colors.green
            : Colors.redAccent);
    if (httpResponsse.isSuccess) {
      model = Vehiculo.fromJson(httpResponsse.data);
      await uploadImage(context);
      clearController();
    } else if (httpResponsse.statusCode == 422) {
      if (httpResponsse.messageError['placa'] != null) {
        print(httpResponsse.messageError['placa']);
        model.placaError = httpResponsse.messageError['placa'].toString();
        notifyListeners();
      }
    }
    textLoadingShowModal = "".toUpperCase();
    changeLoading(false, "".toUpperCase());
    if (!context.mounted) return;
    DialogMessage().snackBar(
        context,
        httpResponsse.message.toString(),
        "",
        httpResponsse.isSuccess
            ? Colors.green
            : Colors.redAccent);
  }

  Future uploadImage(BuildContext context) async {
    if(image == null) return;
    textLoadingShowModal = "cargando imagen esperando...".toUpperCase();
    changeLoading(true, "Cargando imagen".toUpperCase());
    String extension = path.extension(returnImage!.path);
    String filename = model.id.toString() + extension;
    httpResponsse = await controllerGaleriaVehiculo.dioUint8List(model.id, filename, image!);
    print(httpResponsse);
    if (httpResponsse.isSuccess) {
      textLoadingShowModal = "cargando galeria".toUpperCase();
      changeLoading(true, "Cargando galeria".toUpperCase());
      cargarGaleriaVehiculo(model.id);
    }
    textLoadingShowModal = "";
    changeLoading(true, "");
    if(!context.mounted) return;
    DialogMessage().snackBar(
        context,
        httpResponsse.message.toString(),
        "",
        httpResponsse.isSuccess
            ? Colors.green
            : Colors.redAccent);
  }

  Future searchVisitante() async {
    mostrarTabla = false;
    isLoadingSelect = true;
    await queryList(queryController.text);
    isLoadingSelect = false;
    mostrarTabla = true;
  }


  Future searchVehiculoCreate() async {
    mostrarTabla = false;
    isLoadingSelect = true;
    await queryList(placaController.text);
    isLoadingSelect = false;
    mostrarTabla = true;
  }


  Future clearSearchVehiculo() async {
    mostrarTabla = false;
    placaController.text = queryController.text;
    queryController.clear();
    placaController.clear();
    image = null;
    listImagenes = [];
    isRegisteringVehiculo = true;
    skip = 0;
    take = 5;
    lista = [];
  }

  Future recargarLista() async {
    isLoadingSelect = true;
    mostrarTabla = false;
    lista = [];
    skip = 0;
    take = 5;
    await queryListRange();
    isLoadingSelect = false;
  }

  void changeLoading(bool value, String text) {
    isLoading = value;
    textLoading = text;
    notifyListeners();
  }

  Future cargarGaleriaVehiculo(int vehiculo_id) async {
    isLoadingGaleria = true;
    changeLoading(true, "CARGANDO IMAGENES DEL VEHICULO".toUpperCase());
    httpResponsse = await controllerGaleriaVehiculo.getGaleriaVehiculo(vehiculo_id);
    if (httpResponsse.isSuccess) {
      listImagenes = GaleriaVehiculo().parseDynamic(httpResponsse.data);
      notifyListeners();
    }
    isLoadingGaleria = false;
    changeLoading(false, "");
  }

  Future clearOfResidente() async {
    model = Vehiculo(id: 0);
    mostrarTabla = false;
    isRegister = true;
    selectVehiculoController.clear();
    queryController.clear();
    clearController();

    image = null;
    selectedImage = null;
    returnImage = null;
    listImagenes = [];

    if(lista.isEmpty){
      isLoadingSelect = true;
      skip = 0;
      take = 5;
      lista = [];
      await queryListRange();
      isLoadingSelect = false;
    }

  }

  Future clearSelectInputVehiculo() async {
    isLoadingSelect = true;
    selectVehiculoController.clear();
    model = Vehiculo(id: 0);
    lista = [];
    skip = 0;
    take = 5;
    await queryListRange();
    isLoadingSelect = false;
  }

  void clearController() {
    placaController.clear();
    detalleController.clear();
    notifyListeners();
  }

  Future queryList(String query) async {
    if(query.length < 3) return;
    notifyListeners();
    httpResponsse = await controller.consultar(query);
    if (httpResponsse.isSuccess) {
      lista = Vehiculo().parseDynamic(httpResponsse.data);
      counterSearch = httpResponsse.message.toUpperCase();
      notifyListeners();
    }
    notifyListeners();
  }

  Future queryFilter(String query) async {
    if(query.isEmpty) return;
    isLoadingSelect = true;
    httpResponsse = await controller.consultar(query);
    if (httpResponsse.isSuccess) {
      lista = Vehiculo().parseDynamic(httpResponsse.data);
      counterSearch = httpResponsse.message.toUpperCase();
    }
    isLoadingSelect = false;
  }

  Future queryListRange() async {
    if (!hasMore) return;
    httpResponsse = await controller.queryStartEnd(skip, take);
    if (httpResponsse.isSuccess) {
      List<Vehiculo> listado = Vehiculo().parseDynamic(httpResponsse.data);
      counterSearch = httpResponsse.message.toUpperCase();
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

  void cargarDataFormModel() {
    model.placa = placaController.text.toUpperCase();
    model.tipo_vehiculo = tipoVehiculo;
    model.photo_path = '';
    model.detalle = '';
    notifyListeners();
  }

  void updateVisitanteId(Vehiculo modelUpdate) async {
    httpResponsse = await controller.actualizar(modelUpdate);
    print(httpResponsse);
  }

  List<String> get tipoVehiculos => _tipoVehiculos;

  set tipoVehiculos(List<String> value) {
    _tipoVehiculos = value;
  }

  String get tipoVehiculo => _tipoVehiculo;

  set tipoVehiculo(String value) {
    _tipoVehiculo = value;
    notifyListeners();
  }

  Vehiculo get model => _model;

  set model(Vehiculo value) {
    _model = value;
    notifyListeners();
  }

  List<Vehiculo> get lista => _lista;

  set lista(List<Vehiculo> value) {
    _lista = value;
    notifyListeners();
  }

  List<GaleriaVehiculo> get listImagenes => _listImagenes;

  set listImagenes(List<GaleriaVehiculo> value) {
    _listImagenes = value;
    notifyListeners();
  }

  HttpResponsse get httpResponsse => _httpResponsse;

  set httpResponsse(HttpResponsse value) {
    _httpResponsse = value;
    notifyListeners();
  }

  bool get isRegister => _isRegister;

  set isRegister(bool value) {
    _isRegister = value;
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

  String get textCreateUpdateAppBar => _textCreateUpdateAppBar;

  set textCreateUpdateAppBar(String value) {
    _textCreateUpdateAppBar = value;
    notifyListeners();
  }

  String get textAppBar => _textAppBar;

  set textAppBar(String value) {
    _textAppBar = value;
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

  int get skip => _skip;

  set skip(int value) {
    _skip = value;
    notifyListeners();
  }

  File? get selectedImage => _selectedImage;

  set selectedImage(File? value) {
    _selectedImage = value;
    notifyListeners();
  }

  XFile? get returnImage => _returnImage;

  set returnImage(XFile? value) {
    _returnImage = value;
    notifyListeners();
  }
}
