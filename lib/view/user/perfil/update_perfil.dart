import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/user_provider.dart';
import '../../components/metodos/CustomTextFormField.dart';
import '../../components/responsive.dart';
import '../../components/widget/customTextFormField.dart';
import '../../components/widget/dialog.dart';
import '../../components/widget/form_button.dart';
import '../../config/pallet.dart';

//FORMULARIOS DE DATOS PERSONALES
class FormViewProfile extends StatelessWidget {
  const FormViewProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: const Padding(
          padding: EdgeInsets.all(16.0),
          child: FormProfile(),
        ),
        desktop: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25,
              vertical: 16),
          child: const FormProfile(),
        ));
  }
}

class FormProfile extends StatelessWidget {
  const FormProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: context.read<UserProvider>().formProfileKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Text("Modification datos del Perfil",
                  style: TextStyle(fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Text(
                  "ID: ${context.read<UserProvider>().user.id.toString()}",
                  style: const TextStyle(fontSize: 18)),
            ),
            /*Padding(
              padding: const EdgeInsets.all(1),
              child: Text(
                  context.watch<UserProvider>().user.isEmpresa
                      ? "Tipo Usuario: EMPRESA"
                      : "CLIENTE",
                  style: const TextStyle(fontSize: 12)),
            ),*/
            const Divider(),
            //NOMBRE
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomFormField(
                textController: context.watch<UserProvider>().nombreController,
                textInputAction: TextInputAction.next,
                typeText: TextInputType.name,
                hintText: "Juan Perez",
                label: const Text("Nombre: "),
                helperText:
                    context.watch<UserProvider>().user.nombreError.toString(),
                icon: const Icon(Icons.person_2_outlined),
                validator: (value) => CustomText().isValidName(value!),
                onChanged: (value) => CustomText().isValidName(value!),
              ),
            ),
            //RAZON SOCIAL
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomFormField(
                textController:
                    context.watch<UserProvider>().razonSocialController,
                textInputAction: TextInputAction.next,
                typeText: TextInputType.name,
                label: const Text("Razón Social: "),
                hintText: "Administración de Empresas",
                helperText:
                    context.watch<UserProvider>().user.nombreError.toString(),
                icon: const Icon(Icons.person_pin_outlined),
                validator: (value) => CustomText().isValidName(value!),
                onChanged: (value) => CustomText().isValidName(value!),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomFormField(
                textController: context.watch<UserProvider>().nitController,
                typeText: TextInputType.number,
                textInputAction: TextInputAction.next,
                label: const Text("NIT: "),
                hintText: "8956887018",
                helperText: "",
                icon: const Icon(Icons.numbers),
                validator: (value) => CustomText().isValidNumber(value!),
                onChanged: (value) => CustomText().isValidNumber(value!),
              ),
            ),
            //CELULAR
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomFormField(
                textController: context.watch<UserProvider>().celularController,
                typeText: TextInputType.phone,
                textInputAction: TextInputAction.next,
                label: const Text("Celular: "),
                hintText: "73682145",
                helperText: "",
                icon: const Icon(Icons.call),
                validator: (value) => null,
                onChanged: (value) => null,
              ),
            ),
            //DIRECCION
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomFormField(
                textController:
                    context.watch<UserProvider>().direccionController,
                typeText: TextInputType.streetAddress,
                textInputAction: TextInputAction.send,
                label: const Text("Direccion: "),
                hintText: "C/ Isrrael Mendia, #5",
                helperText: "",
                icon: const Icon(Icons.streetview_outlined),
                validator: (value) => null,
                onChanged: (value) => null,
              ),
            ),
            //BOTON
            Padding(
              padding: const EdgeInsets.only(top: defaultPadding),
              child: FormButtom(
                ejecutar: () {
                  if (context
                      .read<UserProvider>()
                      .formProfileKey
                      .currentState!
                      .validate()) {
                    DialogMessage.dialog(
                        context,
                        DialogType.question,
                        "Estas seguro de actualizar los datos del perfil",
                        "", () async {
                      context
                          .read<UserProvider>()
                          .formProfileKey
                          .currentState!
                          .save();
                      //llamar al metodo actualizar perfil
                      Provider.of<UserProvider>(context, listen: false)
                          .modificarPerfil(context);
                    });
                  }
                },
                title: "Actualizar Perfil",
                icon: const Icon(Icons.refresh),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
