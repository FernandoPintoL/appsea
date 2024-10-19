import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/user_provider.dart';
import '../../components/metodos/CustomTextFormField.dart';
import '../../components/widget/customTextFormField.dart';
import '../../components/widget/form_button.dart';
import '../../components/widget/loading.dart';
import '../../config/pallet.dart';

class DatosLoginMobile extends StatefulWidget {
  const DatosLoginMobile({super.key});

  @override
  State<DatosLoginMobile> createState() => _DatosLoginMobileState();
}

class _DatosLoginMobileState extends State<DatosLoginMobile> {
  @override
  Widget build(BuildContext context) {
    return context.watch<UserProvider>().isLoading
        ? Loading(text: "Actualizando Datos de Inicio")
        : Form(
            key: context.watch<UserProvider>().formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Text("Datos de Inicio de Session",
                        style: TextStyle(fontSize: 18)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Text(
                            "Cod: ${context.watch<UserProvider>().user.id}",
                            style: const TextStyle(fontSize: 18)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Text(
                            "Nombre: ${context.watch<UserProvider>().user.name}",
                            style: const TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                  const Divider(),
                  //USERNAME
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CustomFormField(
                      textController:
                          context.watch<UserProvider>().userloginController,
                      typeText: TextInputType.name,
                      label: const Text("User/Nick"),
                      hintText: "perez",
                      helperText: context
                          .watch<UserProvider>()
                          .user
                          .userloginError
                          .toString(),
                      validator: (value) => CustomText().isValidUserName(value),
                      onChanged: (value) => CustomText().isValidUserName(value),
                      icon: const Icon(CupertinoIcons.person),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CustomFormField(
                      textController:
                          context.watch<UserProvider>().emailController,
                      icon: const Icon(CupertinoIcons.mail),
                      typeText: TextInputType.emailAddress,
                      label: const Text("Email"),
                      hintText: "prueba@gmail.com",
                      helperText: context.watch<UserProvider>().user.emailError,
                      validator: (value) => CustomText().isValidEmail(value),
                      onChanged: (value) => CustomText().isValidEmail(value),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: FormButtom(
                      ejecutar: () {
                        context.read<UserProvider>().registerView(context);
                      },
                      title: "Actualizar Datos",
                      icon: const Icon(Icons.refresh),
                    ),
                    // child: FilledButton.tonal(
                    //     style: const ButtonStyle(
                    //         backgroundColor:
                    //             MaterialStatePropertyAll<Color>(Colors.green)),
                    //     onPressed: () async {
                    //       context.read<UserProvider>().registerView(context);
                    //     },
                    //     child: RichText(
                    //       textAlign: TextAlign.center,
                    //       textDirection: TextDirection.ltr,
                    //       text: const TextSpan(
                    //         children: [
                    //           TextSpan(
                    //             style: TextStyle(fontSize: 16),
                    //             text: "Actualizar Datos",
                    //           ),
                    //           WidgetSpan(
                    //             alignment: PlaceholderAlignment.middle,
                    //             child: Icon(Icons.refresh),
                    //           ),
                    //         ],
                    //       ),
                    //     )),
                  )
                ],
              ),
            ));
  }
}
