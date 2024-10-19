import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/dblocal/session_local.dart';
import '../app/models/user_model.dart';
import '../app/providers/session_provider.dart';
import 'components/widget/loading.dart';
import 'ingresos/ingreso_main_view.dart';
import 'login/login_responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  cargandoUserSession() async {
    Usuario user = Usuario();
    if (kIsWeb) {
      ///PORQUE SQFLITE NO FUNCIONA EN LA WEB
      print("es web");
      user.id = 0;
      user.name = "Usuario Web";
      user.email = "usuarioweb@gmail.com";
    } else if (Platform.isAndroid) {
      //CONSULTA SI EXISTE UN USUARIO EN LA BASE DE DATOS LOCAL
      print("es android");
      UserSessionLocal userSessionLocal = UserSessionLocal();
      user = await userSessionLocal.getUsuarioSession();
    }
    if (user.id == 0) {
      // NO EXISTE UN USUARIO
      // Vista Login
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const LoginResponsive()),
          (Route<dynamic> route) => false);
    } else {
      // SI EXISTEN UN USUARIO
      // vista Home
      context.read<SessionProvider>().cargarUserSession(user);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const IngresoView()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargandoUserSession();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(child: Image.asset(globales.imgLogo, fit: BoxFit.fill)),
            const SizedBox(height: 20),
            Loading(text: "Iniciando la app espere porfavor..."),
            const SizedBox(height: 20),
            // Text(mensaje,style: TextStyle(color: Colors.green,fontWeight: FontWeight.w500,fontSize: 18),textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
