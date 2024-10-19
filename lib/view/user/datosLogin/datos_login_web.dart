import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/user_provider.dart';
import '../../components/metodos/CustomTextFormField.dart';
import '../../components/widget/customTextFormField.dart';
import '../../components/widget/loading.dart';
import '../../config/pallet.dart';

class DatosLoginWeb extends StatefulWidget {
  const DatosLoginWeb({super.key});

  @override
  State<DatosLoginWeb> createState() => _DatosLoginWebState();
}

class _DatosLoginWebState extends State<DatosLoginWeb> {
  @override
  Widget build(BuildContext context) {
    return context.watch<UserProvider>().isLoading
        ? Loading(text: "Actualizando Datos")
        : Form(
            key: context.read<UserProvider>().formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Text("Datos de Inicio de Session",
                        style: TextStyle(fontSize: 18)),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: Text(
                                "Cod: ${context.watch<UserProvider>().user.id}",
                                style: const TextStyle(fontSize: 12)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: Text(context.watch<UserProvider>().user.name,
                                style: const TextStyle(fontSize: 18)),
                          ),
                        ],
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
                    child: FilledButton.tonal(
                        onPressed: () async {
                          context.read<UserProvider>().registerView(context);
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                style: TextStyle(fontSize: 16),
                                text: "Actualizar Datos",
                              ),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(Icons.refresh),
                              ),
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          );
  }
}
