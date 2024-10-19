import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/user_provider.dart';
import '../../components/responsive.dart';
import '../../components/widget/image_component.dart';
import '../datosLogin/datos_login_mobile.dart';
import '../datosLogin/datos_login_web.dart';
import '../password/password.dart';
import '../perfil/update_perfil.dart';
import '../perfil_image/perfil_image.dart';

// ACTUALIZAR USUARIO
class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 32),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PerfilImage(
                            imagePath: context
                                .watch<UserProvider>()
                                .user
                                .profilePhotoUrl
                                .toString(),
                            name: context
                                .watch<UserProvider>()
                                .user
                                .name
                                .toString(),
                            isUser: true,
                            id: context.watch<UserProvider>().user.id,
                          )),
                );
              },
              child: ImageComponent(
                  size: 50,
                  function: () {},
                  errorWidget: const CircleAvatar(
                      child: Icon(Icons.person_outline_rounded)),
                  imageUrl: context
                      .watch<UserProvider>()
                      .user
                      .profilePhotoUrl
                      .toString()),
            ),
          )
        ],
      ),
      //body: const FormUser(),
      body: <Widget>[
        const FormViewDataLoginUser(),
        const FormViewProfile(),
        const FormViewPassword(),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.transparent,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber[800],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Datos de Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.school),
            icon: Icon(Icons.school_outlined),
            label: 'Datos Personales',
          ),
          NavigationDestination(
            icon: Icon(Icons.business),
            label: 'Cambiar Contraseña',
          ),
        ],
      ),
    );
  }
}

// FORMULARIOS PARA INICIO DE SESSION
class FormViewDataLoginUser extends StatelessWidget {
  const FormViewDataLoginUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: const Padding(
          padding: EdgeInsets.all(16.0),
          child: DatosLoginMobile(),
        ),
        desktop: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25,
              vertical: 16),
          child: const DatosLoginWeb(),
        ));
  }
}
