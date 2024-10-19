import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sea/app/dblocal/condominio_local.dart';

import '../../view/components/widget/dialog.dart';
import '../../view/ingresos/ingreso_main_view.dart';
import '../../view/login/login_responsive.dart';
import '../controller/user_controller.dart';
import '../dblocal/session_local.dart';
import '../models/condominio_model.dart';
import '../models/http_response.dart';
import '../models/user_model.dart';

class SessionProvider extends ChangeNotifier {
  final GlobalKey<ScaffoldState> scaffoldkeyCreate = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> scaffoldkeyLogin = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKeyCreate = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController nickController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  bool terms = false;

  TextEditingController loginNickController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  UserSessionLocal userSessionLocal = UserSessionLocal();
  CondominioLocal condominioLocal = CondominioLocal();

  String? nameError;
  String? nickError;
  String? emailError;
  String? passwordError;
  String? passwordConfirmationError;
  String textLoading = "Cargando...".toUpperCase();

  Usuario userSession = Usuario();
  UserController controller = UserController();
  HttpResponsse _httpResponsse = HttpResponsse(false, false, true, "", "", [], 500);

  bool isLoading = false;
  bool isSubmit = false;
  bool passwordInput = true;
  bool passwordConfirmacionInput = true;
  bool loginPasswordInput = true;
  bool isSelectedMenu = true;
  int posicionMenu = 0;

  cargarUserSession(Usuario user) {
    userSession = user;
    notifyListeners();
  }

  changeLoginPassword() {
    loginPasswordInput = !loginPasswordInput;
    notifyListeners();
  }

  changePassword() {
    passwordInput = !passwordInput;
    notifyListeners();
  }

  changePasswordConfirmacion() {
    passwordConfirmacionInput = !passwordConfirmacionInput;
    notifyListeners();
  }

  changeTerms() {
    terms = !terms;
    notifyListeners();
  }

  clearLogin() {
    loginNickController.clear();
    loginPasswordController.clear();
    formKeyLogin.currentState?.reset();
    notifyListeners();
  }

  clearCreate() {
    nameController.clear();
    nickController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    formKeyCreate.currentState?.reset();
    notifyListeners();
  }

  registerUser(BuildContext context) {
    isSubmit = true;
    notifyListeners();
    if (formKeyCreate.currentState!.validate()) {
      formKeyCreate.currentState!.save();
      userSession.name = nameController.text;
      userSession.usernick = nickController.text;
      userSession.email = emailController.text;
      userSession.password = passwordController.text;
      userSession.passwordRepeat = passwordConfirmationController.text;
      userSession.terms = terms;
      notifyListeners();
      if (!context.mounted) return;
      DialogMessage.dialog(context, DialogType.question, "Estas Seguro que deseas registrar estos datos?", "",
          () async {
        registrando(context);
      });
    } else {
      if (!context.mounted) return;
      DialogMessage.dialog(context, DialogType.error, "Complete el formulario correctamente", "", () {});
    }
  }

  registrando(BuildContext context) async {
    httpResponsse = await controller.registerOnApi(userSession);
    if (!context.mounted) return;
    DialogMessage.dialog(context, httpResponsse.isSuccess ? DialogType.success : DialogType.error,
        httpResponsse.message.toString(), httpResponsse.data.toString(), () {
      if (httpResponsse.isSuccess) {
        userSession = Usuario.fromJson(httpResponsse.data);
        loginNickController.text = userSession.usernick;
        clearCreate();
        print("moviendo......................");
        Navigator.pop(context);
      } else if (httpResponsse.messageError) {
        dynamic message = httpResponsse.message;
        if (message["name"] != null) nameError = message["name"].toString();
        if (message["email"] != null) emailError = message["email"].toString();
        if (message["nick"] != null) nickError = message["nick"].toString();
        if (message["password"] != null) passwordError = message["password"].toString();
      }
      notifyListeners();
    });
  }

  Future login(BuildContext context) async {
    if (formKeyLogin.currentState!.validate()) {
      formKeyLogin.currentState!.save();
      notifyListeners();
      await loginController(context);
    } else {
      if (!context.mounted) return;
      DialogMessage().snackBar(context, "Complete el formulario correctamente", "", Colors.yellow);
    }
  }

  Future loginController(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    httpResponsse = await controller.loginOnApi(loginNickController.text, loginPasswordController.text);
    print(httpResponsse.toString());
    isLoading = false;
    notifyListeners();
    if (httpResponsse.isSuccess) {
      if (!kIsWeb) {
        userSession = Usuario.fromJson(httpResponsse.data);
        print(userSession);
        bool crear_usuario = await userSessionLocal.guardarUsuarioSession(userSession);
        bool crear_condominio = await condominioLocal.guardarUsuarioSession(userSession.condominio);
      }
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const IngresoView()),
          (Route<dynamic> route) => false);
    } else {
      if(httpResponsse.message.toUpperCase().contains('password'.toUpperCase())){
        nameError = null;
        passwordError = httpResponsse.message.toUpperCase();
        notifyListeners();
      }else{
        passwordError = null;
        nameError = httpResponsse.message.toUpperCase();
        notifyListeners();
      }
      if (!context.mounted) return;
      DialogMessage().snackBar(context,
          httpResponsse.message.toString(), "", Colors.red);
    }
  }

  logout(BuildContext context) async {
    if (!context.mounted) return;
    DialogMessage.dialog(context, DialogType.info, "Estas seguro de cerrar sessión?", "", () async {
      httpResponsse = await UserController().logout();
      if (httpResponsse.isSuccess) {
        bool response = await userSessionLocal.cerrarSession(userSession);
        Condominio condominio = await condominioLocal.getCondominio();
        bool responsse = await condominioLocal.eliminarCondominio(condominio);
        if(!context.mounted) return;
        if (response) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) => const LoginResponsive()),
              (Route<dynamic> route) => false);
        } else {
          if (!context.mounted) return;
          DialogMessage.dialog(context, DialogType.error, "No se elimino la session de la base datos local", "", () {});
        }
      } else {
        if (!context.mounted) return;
        DialogMessage.dialog(context, httpResponsse.isSuccess ? DialogType.success : DialogType.error,
            httpResponsse.message.toString(), "", () {});
      }
    });
  }

  HttpResponsse get httpResponsse => _httpResponsse;

  set httpResponsse(HttpResponsse value) {
    _httpResponsse = value;
  }
}
