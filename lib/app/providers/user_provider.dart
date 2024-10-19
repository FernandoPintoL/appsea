import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../../view/components/widget/dialog.dart';
import '../controller/user_controller.dart';
import '../models/http_response.dart';
import '../models/perfil_model.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  Usuario user = Usuario();
  // Empresa empresa = Empresa();
  // Cliente cliente = Cliente();
  Perfil perfil = Perfil();
  List<Usuario> lista = [];

  // List<TipoUser> listTipoUser = [];
  // TipoUser tipoUser = TipoUser();
  UserController controller = UserController();
  //EmpresaController empresaController = EmpresaController();

  // TipoUserController tipoUserController = TipoUserController();
  GlobalKey<ScaffoldState> scaffoldkeyUsers = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formPasswordKey = GlobalKey<FormState>();
  GlobalKey<FormState> formProfileKey = GlobalKey<FormState>();

  //GlobalKey<FormState> formProfileKey = GlobalKey<FormState>();

  TextEditingController nombreController = TextEditingController();
  TextEditingController razonSocialController = TextEditingController();
  TextEditingController nitController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userloginController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController queryController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  bool isEmpresa = false;

  bool isObscureText = true;
  bool isObscureTextRepeat = true;
  bool isObscureTextNew = true;

  String titleForm = "REGISTRA TU NUEVO USUARIO";
  bool isRegister = true;
  String tittleButtom = "Registrar Usuario";

  Widget container = const Center(child: Text('Iniciando Page...'));

  // Secciones currentPage = Secciones.listado;
  bool isLoading = false;
  HttpResponsse _httpResponsse = HttpResponsse(false, false, true, "", "", [], 500);

  UserProvider() {
    cargandoLista("");
  }

  void userEdit(Usuario usuario) {
    user = usuario;
    notifyListeners();
  }

  void dispenar() {}

  void clearInputs() {
    nombreController.clear();
    razonSocialController.clear();
    nitController.clear();
    newPasswordController.clear();
    passwordController.clear();
    repeatPasswordController.clear();
    userloginController.clear();
    emailController.clear();
    notifyListeners();
  }

  void changeIsEmpresa() {
    isEmpresa = !isEmpresa;
    notifyListeners();
  }

  void changeObscureText() {
    isObscureText = !isObscureText;
    notifyListeners();
  }

  void changeObscureTextRepeat() {
    isObscureTextRepeat = !isObscureTextRepeat;
    notifyListeners();
  }

  void changeObscureTextNew() {
    isObscureTextNew = !isObscureTextNew;
    notifyListeners();
  }

  void cargandoLista(String query) async {
    isLoading = true;
    notifyListeners();
    httpResponsse = await controller.consultar(query);
    if (httpResponsse.isRequest && httpResponsse.isSuccess) {
      lista = Usuario().parseDynamic(httpResponsse.data);
      notifyListeners();
    }
    isLoading = false;
    notifyListeners();
  }

  void registerView(BuildContext context) async {
    if (!formKey.currentState!.mounted) return;
    if (formKey.currentState!.validate()) {
      if (!context.mounted) return;
      DialogMessage.dialog(
          context,
          DialogType.question,
          isRegister
              ? "Estas Seguro que deseas registrar estos datos?"
              : "Estas Seguro que deseas actualizar estos datos?",
          "", () async {
        formKey.currentState!.save();
        registrando(context);
      });
    }
  }

  void registrando(BuildContext context) async {
    //CREANDO EL USUARIO
    isLoading = true;
    notifyListeners();
    user.name = nombreController.text;
    user.email = emailController.text;
    user.usernick = userloginController.text;
    if (isRegister) {
      user.password = passwordController.text;
      user.passwordRepeat = repeatPasswordController.text;
      httpResponsse = await controller.insertar(user);
      if (httpResponsse.isSuccess) {
        //crear datos de cliente o empresa segun la eleccion
        user = Usuario.fromJson(httpResponsse.data);
        perfil = Perfil(
            id: 0,
            email: user.email,
            nombre: user.name,
            celular: "",
            direccion: "",
            // estado: "R",
            nroDocumento: "");
        /*empresa = Empresa(
            id: 0,
            nit: nitController.text,
            razon_social: razonSocialController.text,
            propietario: nombreController.text,
            user_id: user.id,
            perfil_id: 0);
        empresa.perfil = perfil;
        httpResponsse = await EmpresaController().insertar(empresa);*/
      } else if (httpResponsse.messageError) {
        if (httpResponsse.message['name'] != null) {
          user.nombreError = httpResponsse.message['name'].toString();
        }
        if (httpResponsse.message['email'] != null) {
          user.emailError = httpResponsse.message['email'].toString();
        }
        if (httpResponsse.message['userlogin'] != null) {
          user.userloginError = httpResponsse.message['userlogin'].toString();
        }
        notifyListeners();
      }
    } else {
      httpResponsse = await controller.actualizar(user);
    }
    isLoading = false;
    notifyListeners();
    if (!context.mounted) return;
    DialogMessage.dialog(
        context,
        httpResponsse.isSuccess ? DialogType.success : DialogType.error,
        httpResponsse.message.toString(),
        httpResponsse.data.toString(), () async {
      if (httpResponsse.isSuccess) {
        formKey.currentState!.reset();
        passwordController.clear();
        newPasswordController.clear();
        repeatPasswordController.clear();
        isEmpresa = false;
        user = Usuario();
        // empresa = Empresa();
        notifyListeners();
        cargandoLista("");
      }
    });
  }

  void updatePerfil(BuildContext context) async {
    /*empresa = Empresa(
      id: 0,
    );*/
  }

  void eliminando(BuildContext context, Usuario usuario) async {
    isLoading = true;
    notifyListeners();
    httpResponsse = await controller.delete(usuario);
    isLoading = false;
    notifyListeners();
    cargandoLista("");
    if (!context.mounted) return;
    DialogMessage().snackBar(
        context,
        httpResponsse.message,
        httpResponsse.data.toString(),
        httpResponsse.isRequest && httpResponsse.isSuccess
            ? Colors.greenAccent.withOpacity(0.80)
            : Colors.redAccent);
  }

  void changePassword(BuildContext context) async {
    Map<String, dynamic> data = {
      "current_password": passwordController.text.toString(),
      "password": newPasswordController.text.toString()
    };
    httpResponsse = await controller.updatePassword(data, user);
    if (!context.mounted) return;
    DialogMessage().snackBar(
        context,
        httpResponsse.message,
        httpResponsse.data.toString(),
        httpResponsse.isRequest && httpResponsse.isSuccess
            ? Colors.greenAccent.withOpacity(0.80)
            : Colors.redAccent);
    if (httpResponsse.isRequest && httpResponsse.isSuccess) {
      formPasswordKey.currentState!.reset();
      passwordController.clear();
      repeatPasswordController.clear();
      newPasswordController.clear();
    }
  }

  void modificarPerfil(BuildContext context) async {
    if (!formProfileKey.currentState!.validate()) return;
    /*empresa = Empresa(
      id: user.empresa.id,
      user_id: user.id,
      perfil_id: user.empresa.perfil_id,
      nit: nitController.text,
      razon_social: razonSocialController.text,
      propietario: nombreController.text,
    );
    empresa.perfil = Perfil(
        id: user.empresa.perfil_id,
        celular: celularController.text,
        direccion: direccionController.text,
        nombre: nombreController.text,
        photoUrl: user.profilePhotoUrl,
        email: user.email,
        estado: "R");
    print(empresa.toString());
    print(empresa.perfil.toString());

    httpResponsse = await EmpresaController().actualizar(empresa);*/

    if (!context.mounted) return;
    DialogMessage.dialog(
        context,
        httpResponsse.isSuccess ? DialogType.success : DialogType.error,
        httpResponsse.message.toString(),
        httpResponsse.data.toString(), () async {
      cargandoLista("");
    });
  }

  void openFormularioRegister() {
    clearInputs();
    titleForm = "REGISTRA LA TU USUARIO";
    tittleButtom = "Registra tu usuario";
    isRegister = true;
    user = Usuario();
    perfil = Perfil();
    //empresa = Empresa();
    //cliente = Cliente();
    notifyListeners();
  }

  void openUserUpdate(Usuario usuario) async {
    user = usuario;
    //httpResponsse = await EmpresaController().showPerfil(usuario.id.toString());
    //user.empresa.perfil = Perfil.fromJson(httpResponsse.data);
    nombreController.text = usuario.name;
    emailController.text = usuario.email;
    userloginController.text = usuario.usernick;
    //nitController.text = usuario.empresa.nit;
    //razonSocialController.text = usuario.empresa.razon_social;
    //celularController.text = usuario.empresa.perfil.celular;
    //direccionController.text = usuario.empresa.perfil.direccion;
    notifyListeners();
  }

  void consultando(BuildContext context) async {
    print(queryController.text);
    cargandoLista(queryController.text);
  }

  HttpResponsse get httpResponsse => _httpResponsse;

  set httpResponsse(HttpResponsse value) {
    _httpResponsse = value;
  }
}
