import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../view/components/widget/dialog.dart';
import '../controller/galeria_visitante_controller.dart';
import '../controller/tipo_documento_controller.dart';
import '../controller/visitante_controller.dart';
import '../models/galeria_visitante_model.dart';
import '../models/http_response.dart';
import '../models/perfil_model.dart';
import '../models/tipo_documento_model.dart';
import '../models/visitante_model.dart';
import 'package:path/path.dart' as path;

class VisitanteProvider extends ChangeNotifier {
  //MODELOS
  Visitante _model = Visitante();

  //para las creaciones
  Perfil _perfil = Perfil();
  TipoDocumento _tipoDocumento = TipoDocumento();

  //LISTAS
  List<Visitante> _lista = [];
  List<TipoDocumento> _listTipoDocumento = [];

  // DATOS PARA SU GALERIA
  List<GaleriaVisitante> _listImagenes = [];
  Uint8List? _image;
  File? _selectedImage;
  XFile? _returnImage;

  //CONTROLLERS
  HttpResponsse _httpResponsse = HttpResponsse(false, false, true, "", "", [], 500);
  VisitanteController controller = VisitanteController();
  TipoDocumentoController controllerTipoDocumento = TipoDocumentoController();
  GaleriaVisitanteController controllerGaleriaVisitante = GaleriaVisitanteController();

  //FORM KEY
  GlobalKey<ScaffoldState> scaffoldkeyVisitantes = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController selectVisitanteController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController nroDocumentoController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController queryController = TextEditingController();

  // bool isRequiredQuery = true;
  bool _isRegister = true;
  bool _isRegister_formLayout = false;

  // bool isRegisterGaleria = false;
  bool _isLoading = false;
  bool _isLoadingSelect = false;

  bool get isLoadingSelect => _isLoadingSelect;

  set isLoadingSelect(bool value) {
    _isLoadingSelect = value;
   notifyListeners();
  }
  // bool isResetForm = false;
  bool _isBlackList = false;
  String _textLoading = "Cargando Listado...";
  String _textLoadingShowModal = "";
  String? _counterSearch;

  String? get counterSearch => _counterSearch;

  set counterSearch(String? value) {
    _counterSearch = value;
    notifyListeners();
  }
  // String textCreateUpdateAppBar = "Registrar nueva información";
  String _textAppBar = "Gestión de Visitantes";

  // String visitantesCargados = "";

  int _skip = 0;
  int _take = 5;
  bool _hasMore = true;
  bool _isScrolleable = true;

  bool _mostrarTabla = false;
  bool _focusListView = false;

  bool get isLoadingGaleria => _isLoadingGaleria;

  set isLoadingGaleria(bool value) {
    _isLoadingGaleria = value;
    notifyListeners();
  }

  bool _isLoadingGaleria = false;

  bool get focusListView => _focusListView;

  set focusListView(bool value) {
    _focusListView = value;
    notifyListeners();
  }

  bool get mostrarTabla => _mostrarTabla;


  void changeMostrarTabla(){
    mostrarTabla = !mostrarTabla;
  }

  set mostrarTabla(bool value) {
    _mostrarTabla = value;
    notifyListeners();
  }

  ///CONSTRUCTOR
  VisitanteProvider() {
    /*if (lista.isEmpty) {
      print("-------------LLAMANDO DESDE EL CONSTRUCTOR ------------------");
      queryListRange();
    }*/
  }

  void registerVisitanteImage(BuildContext context) async{
    // await registrarModelo();

  }

  ///METODO REGISTRAR VISITANTE
  Future registrarModelo(BuildContext context) async {
    changeLoading(true, "Registrando Visitante".toUpperCase());
    textLoadingShowModal = "Registrando Visitante".toUpperCase();
    cargarDataFormVisitante();
    httpResponsse = await controller.insertar(model);
    print(httpResponsse);
    changeLoading(false, "");
    if (!context.mounted) return;
    DialogMessage().snackBar(
        context,
        httpResponsse.message.toString(),
        "",
        httpResponsse.isSuccess
            ? Colors.green
            : Colors.redAccent);
    if (httpResponsse.isSuccess) {
      model = Visitante.fromJson(httpResponsse.data);
      await uploadImage(context);
      clearController();
      isRegister = false;
      isRegister_formLayout = false;

      ///PARA QUE NO VUELVA A REGISTRAR
    } else if (httpResponsse.statusCode == 422) {
      if (httpResponsse.messageError['nroDocumento'] != null) {
        model.nroDocumentoError = httpResponsse.messageError['nroDocumento'].toString();
      }
      isRegister = true;
      isRegister_formLayout = true;
      ///PARA QUE VUELVA A REGISTRAR
    } else {
      isRegister = true;
      isRegister_formLayout = true;
      ///PARA QUE VUELVA A REGISTRAR
    }
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
    httpResponsse = await controllerGaleriaVisitante.dioUint8List(model.id, filename, image!);
    print(httpResponsse);
    if (httpResponsse.isSuccess) {
      textLoadingShowModal = "cargando galeria".toUpperCase();
      changeLoading(true, "Cargando galeria".toUpperCase());
      cargarGaleriaVisitantes(model.id);
      isRegister_formLayout = false;
    } else {
      isRegister_formLayout = true;
    }
    textLoadingShowModal = "";
    changeLoading(true, "");
    if (!context.mounted) return;
    DialogMessage().snackBar(
        context,
        httpResponsse.message.toString(),
        "",
        httpResponsse.isSuccess
            ? Colors.green
            : Colors.redAccent);
  }

  Future clearSearchVisitante() async {
    mostrarTabla = false;
    queryController.clear();
    image = null;
    listImagenes = [];
    lista = [];
    /*skip = 0;
    take = 5;
    isLoadingSelect = true;
    await queryListRange();
    isLoadingSelect = false;*/
  }

  Future recargarLista() async {
    isLoadingSelect = true;
    mostrarTabla = false;
    clearList();
    await queryListRange();
    isLoadingSelect = false;
  }

  Future searchVisitante() async {
    mostrarTabla = false;
    isLoadingSelect = true;
    await queryList(queryController.text);
    isLoadingSelect = false;
    mostrarTabla = true;
  }

  Future cargarGaleriaVisitantes(int visitante_id) async {
    isLoadingGaleria = true;
    changeLoading(true, "CARGANDO IMAGENES DEL VISITANTE".toUpperCase());
    httpResponsse = await controllerGaleriaVisitante.getGaleriaVisitante(visitante_id);
    if (httpResponsse.isSuccess) {
      listImagenes = GaleriaVisitante().parseDynamic(httpResponsse.data);
    }
    isLoadingGaleria = false;
    changeLoading(false, "");
  }

  Future queryList(String query) async {
    if(query.length < 3) return;
    httpResponsse = await controller.consultar(query, isBlackList);
    if (httpResponsse.isSuccess) {
      lista = Visitante().parseDynamic(httpResponsse.data);
      counterSearch = httpResponsse.message.toUpperCase();
      notifyListeners();
    }
  }

  Future queryListRange() async {
    if (!hasMore) return;
    httpResponsse = await controller.queryStartEnd(skip, take);
    if (httpResponsse.isSuccess) {
      List<Visitante> listado = Visitante().parseDynamic(httpResponsse.data);
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

  Future cargarListTipoDocumento() async {
    isLoading = true;
    textLoading = "Cargando Listado de Documentos".toUpperCase();
    notifyListeners();
    httpResponsse = await controllerTipoDocumento.consultar("");
    if (httpResponsse.isSuccess) {
      listTipoDocumento = TipoDocumento().parseDynamic(httpResponsse.data);
      if (listTipoDocumento.isNotEmpty) {
        if (isRegister) {
          tipoDocumento = listTipoDocumento.first;
          notifyListeners();
        } else {
          if (model.perfil.tipo_documento_id != 0) {
            tipoDocumento = listTipoDocumento.firstWhere((element) => element.id == model.perfil.tipo_documento_id);
            notifyListeners();
          } else {
            tipoDocumento = listTipoDocumento.first;
            notifyListeners();
          }
        }
      } else {
        tipoDocumento = TipoDocumento();
        notifyListeners();
      }
      notifyListeners();
    }
    isLoading = false;
    textLoading = "";
    notifyListeners();
  }

  Future clearOfResidente() async {
    mostrarTabla = false;
    model = Visitante(id: 0);
    isRegister = true;
    selectVisitanteController.clear();
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

  Future cargarFormulario() async {
    isRegister = true;
    clearController();
    nameController.text = queryController.text;
    queryController.clear();
    mostrarTabla = false;
    textAppBar = "Cargando formulario".toString();
    image = null;
    returnImage = null;
    if(listTipoDocumento.isEmpty){
      await cargarListTipoDocumento();
    }
  }

  void clearList() {
    queryController.clear();
    skip = 0;
    take = 5;
    hasMore = true;
    isScrolleable = true;
    lista = [];
    notifyListeners();
  }

  void changeLoading(bool value, String text) {
    isLoading = value;
    textLoading = text;
    textLoadingShowModal = text;
    notifyListeners();
  }

  void clearController() {
    nameController.clear();
    nroDocumentoController.clear();
    celularController.clear();
    notifyListeners();
  }

  Future clearSelectInputVisitante() async {
    isLoadingSelect = true;
    selectVisitanteController.clear();
    model = Visitante(id: 0);
    lista = [];
    skip = 0;
    take = 5;
    await queryListRange();
    isLoadingSelect = false;
  }

  void cargarDataTipoDocumento(TipoDocumento modelTipoDocumento) {
    tipoDocumento = modelTipoDocumento;
    model.perfil.tipoDocumento = modelTipoDocumento;
    model.perfil.tipo_documento_id = modelTipoDocumento.id;
    notifyListeners();
  }

  Future queryFilter(String query) async {
    if(query.isEmpty) return;
    isLoadingSelect = true;
    lista = [];
    httpResponsse = await controller.consultar(query, false);
    if (httpResponsse.isSuccess) {
      lista = Visitante().parseDynamic(httpResponsse.data);
      counterSearch = httpResponsse.message.toUpperCase();
    }
    isLoadingSelect = false;
  }

  void cargarDataFormVisitante() {
    model = Visitante(perfil_id: 0, is_permitido: true, descripition_is_no_permitido: "");
    perfil = Perfil(
        nombre: nameController.text.isEmpty ? '' : nameController.text.toUpperCase(),
        celular: celularController.text.isEmpty ? '' : celularController.text,
        nroDocumento: nroDocumentoController.text.isEmpty ? '' : nroDocumentoController.text.toUpperCase(),
        tipo_documento_id: tipoDocumento.id,
        email: '',
        direccion: '',
        id: 0);
    model.perfil = perfil;
    notifyListeners();
  }

  Visitante get model => _model;

  set model(Visitante value) {
    _model = value;
    notifyListeners();
  }

  Perfil get perfil => _perfil;

  set perfil(Perfil value) {
    _perfil = value;
    notifyListeners();
  }

  TipoDocumento get tipoDocumento => _tipoDocumento;

  set tipoDocumento(TipoDocumento value) {
    _tipoDocumento = value;
    notifyListeners();
  }

  List<Visitante> get lista => _lista;

  set lista(List<Visitante> value) {
    _lista = value;
    notifyListeners();
  }

  List<TipoDocumento> get listTipoDocumento => _listTipoDocumento;

  set listTipoDocumento(List<TipoDocumento> value) {
    _listTipoDocumento = value;
    notifyListeners();
  }

  List<GaleriaVisitante> get listImagenes => _listImagenes;

  set listImagenes(List<GaleriaVisitante> value) {
    _listImagenes = value;
    notifyListeners();
  }

  Uint8List? get image => _image;

  set image(Uint8List? value) {
    _image = value;
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

  bool get isRegister_formLayout => _isRegister_formLayout;

  set isRegister_formLayout(bool value) {
    _isRegister_formLayout = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isBlackList => _isBlackList;

  set isBlackList(bool value) {
    _isBlackList = value;
    notifyListeners();
  }

  String get textLoading => _textLoading;

  set textLoading(String value) {
    _textLoading = value;
    notifyListeners();
  }

  String get textLoadingShowModal => _textLoadingShowModal;

  set textLoadingShowModal(String value) {
    _textLoadingShowModal = value;
    notifyListeners();
  }

  String get textAppBar => _textAppBar;

  set textAppBar(String value) {
    _textAppBar = value;
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

/*
  registrarModelMessage(BuildContext context) {
    if (!formKey.currentState!.mounted) return;
    if (formKey.currentState!.validate()) {
      if (!context.mounted) return;
      DialogMessage.dialog(context, DialogType.question, "¿Desesas registrar estos datos?", "", () {
        registrarModel(context);
      });
    } else {
      if (!context.mounted) return;
      DialogMessage().snackBar(context, "FORMULARIO NO VALIDADO", "", Colors.redAccent);
    }
  }
*/

/*registrarModel(BuildContext context) async {
    isLoading = true;
    textLoading = "Registrando Datos...";
    httpResponsse = HttpResponsse();
    notifyListeners();
    model = Visitante(
      perfil_id: 0,
    );
    perfil = Perfil(
        nombre: nameController.text.isEmpty ? '' : nameController.text.toUpperCase(),
        celular: celularController.text.isEmpty ? '' : celularController.text,
        nroDocumento: nroDocumentoController.text.isEmpty ? '' : nroDocumentoController.text,
        tipo_documento_id: tipoDocumento.id,
        email: '',
        direccion: '',
        id: 0);
    model.perfil = perfil;
    httpResponsse = await controller.insertar(model);
    print(httpResponsse);
    if (httpResponsse.success) {
      model = Visitante.fromJson(httpResponsse.data);
      clearController();
      /*queryListId(model.id.toString());
      isRegister = false;
      isRequiredQuery = false;
      isResetForm = true;*/
    }
    isLoading = false;
    notifyListeners();
    // DialogMessage().snackBar(context, httpResponsse.message, "", Colors.redAccent);
  }*/
}
