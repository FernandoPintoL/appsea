import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/user_provider.dart';
import '../../components/metodos/CustomTextFormField.dart';
import '../../components/widget/customTextFormField.dart';
import '../../components/widget/dialog.dart';
import '../../components/widget/loading.dart';
import '../../config/pallet.dart';

class RegisterUserDesktop extends StatelessWidget {
  const RegisterUserDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return context.watch<UserProvider>().isLoading
        ? Loading(text: "Registrando usuario")
        : Form(
            key: context.read<UserProvider>().formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text("Registro de Usuario",
                        style: TextStyle(fontSize: 18)),
                  ),
                  //TIPO DE REGISTRO
                  context.read<UserProvider>().isRegister
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("¿Deseas registrarte como empresa?"),
                              //DropDownButtonSearchTipoUser(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: RadioListTile<bool>(
                                      title: const Text('Si'),
                                      value: true,
                                      groupValue: context
                                          .watch<UserProvider>()
                                          .isEmpresa,
                                      onChanged: (bool? value) {
                                        context
                                            .read<UserProvider>()
                                            .changeIsEmpresa();
                                        print("seleccionado empresa");
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<bool>(
                                      title: const Text('No'),
                                      value: false,
                                      groupValue: context
                                          .watch<UserProvider>()
                                          .isEmpresa,
                                      onChanged: (bool? value) {
                                        context
                                            .read<UserProvider>()
                                            .changeIsEmpresa();
                                        print("seleccionado cliente");
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      : const SizedBox(width: 1),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: CustomFormField(
                      textController:
                          context.watch<UserProvider>().nombreController,
                      typeText: TextInputType.name,
                      hintText: "Juan Perez",
                      label: Text(context.watch<UserProvider>().isEmpresa
                          ? "Propietario:"
                          : "Nombre:"),
                      helperText: context
                          .watch<UserProvider>()
                          .user
                          .nombreError
                          .toString(),
                      icon: const Icon(CupertinoIcons.person_3),
                      validator: (value) => CustomText().isValidName(value!),
                      onChanged: (value) => CustomText().isValidName(value!),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
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
                          validator: (value) =>
                              CustomText().isValidUserName(value),
                          onChanged: (value) =>
                              CustomText().isValidUserName(value),
                          icon: const Icon(CupertinoIcons.person),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: CustomFormField(
                          textController:
                              context.watch<UserProvider>().emailController,
                          icon: const Icon(CupertinoIcons.mail),
                          typeText: TextInputType.emailAddress,
                          label: const Text("Email"),
                          hintText: "prueba@gmail.com",
                          helperText:
                              context.watch<UserProvider>().user.emailError,
                          validator: (value) =>
                              CustomText().isValidEmail(value),
                          onChanged: (value) =>
                              CustomText().isValidEmail(value),
                        ),
                      ))
                    ],
                  ),
                  context.read<UserProvider>().isRegister
                      ? Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: CustomFormField(
                                textController: context
                                    .watch<UserProvider>()
                                    .passwordController,
                                icon: const Icon(CupertinoIcons.padlock_solid),
                                typeText: TextInputType.text,
                                label: const Text("Password"),
                                hintText: "password",
                                helperText: "",
                                obscureText:
                                    context.watch<UserProvider>().isObscureText,
                                validator: (value) =>
                                    CustomText().isValidPassword(value),
                                onChanged: (value) =>
                                    CustomText().isValidPassword(value),
                                viewText: () {
                                  context
                                      .read<UserProvider>()
                                      .changeObscureText();
                                },
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: CustomFormField(
                                textController: context
                                    .watch<UserProvider>()
                                    .repeatPasswordController,
                                icon: const Icon(CupertinoIcons.padlock_solid),
                                typeText: TextInputType.text,
                                label: const Text("Repetir Password"),
                                hintText: "password",
                                helperText: "",
                                obscureText: context
                                    .watch<UserProvider>()
                                    .isObscureTextRepeat,
                                validator: (value) {
                                  if (CustomText()
                                          .isValidPasswordRepeat(value) !=
                                      null) {
                                    return CustomText()
                                        .isValidPasswordRepeat(value);
                                  } else if (context
                                          .read<UserProvider>()
                                          .repeatPasswordController
                                          .text !=
                                      context
                                          .read<UserProvider>()
                                          .passwordController
                                          .text) {
                                    return "Los campos son distintos";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  if (CustomText()
                                          .isValidPasswordRepeat(value) !=
                                      null) {
                                    return CustomText()
                                        .isValidPasswordRepeat(value);
                                  } else if (context
                                          .read<UserProvider>()
                                          .repeatPasswordController
                                          .text !=
                                      context
                                          .read<UserProvider>()
                                          .passwordController
                                          .text) {
                                    return "Los campos son distintos";
                                  }
                                  return null;
                                },
                                viewText: () {
                                  context
                                      .read<UserProvider>()
                                      .changeObscureTextRepeat();
                                },
                              ),
                            )),
                          ],
                        )
                      : const SizedBox(width: 1),
                  context.watch<UserProvider>().isEmpresa
                      ? Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: CustomFormField(
                                textController:
                                    context.watch<UserProvider>().nitController,
                                typeText: TextInputType.number,
                                hintText: "8956887018",
                                label: const Text("NIT"),
                                helperText: "",
                                icon: const Icon(Icons.numbers),
                                validator: (value) =>
                                    CustomText().isValidNumber(value!),
                                onChanged: (value) =>
                                    CustomText().isValidNumber(value!),
                              ),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: CustomFormField(
                                textController: context
                                    .watch<UserProvider>()
                                    .razonSocialController,
                                typeText: TextInputType.name,
                                hintText: "Comercial Precio Fijo",
                                label: const Text("Razon Social"),
                                helperText: "",
                                icon: const Icon(
                                    CupertinoIcons.person_crop_rectangle),
                                validator: (value) =>
                                    CustomText().isValidName(value!),
                                onChanged: (value) =>
                                    CustomText().isValidName(value!),
                              ),
                            )),
                          ],
                        )
                      : const SizedBox(width: 1),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: FilledButton.tonal(
                        onPressed: () async {
                          if (context
                              .read<UserProvider>()
                              .formKey
                              .currentState!
                              .validate()) {
                            DialogMessage.dialog(
                                context,
                                DialogType.question,
                                context.read<UserProvider>().isRegister
                                    ? "Estas Seguro que deseas registrar estos datos?"
                                    : "Estas Seguro que deseas actualizar estos datos?",
                                "", () async {
                              context
                                  .read<UserProvider>()
                                  .formKey
                                  .currentState!
                                  .save();
                              Provider.of<UserProvider>(context, listen: false)
                                  .registrando(context);
                            });
                          }
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                style: const TextStyle(fontSize: 16),
                                text: context.read<UserProvider>().isRegister
                                    ? "Registrar"
                                    : "Actualizar",
                              ),
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child:
                                    Icon(CupertinoIcons.person_2_square_stack),
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
