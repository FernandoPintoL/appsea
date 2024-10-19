import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/user_provider.dart';
import '../../components/metodos/CustomTextFormField.dart';
import '../../components/widget/customTextFormField.dart';
import '../../components/widget/loading.dart';
import '../../config/pallet.dart';

class RegisterUserMobile extends StatelessWidget {
  const RegisterUserMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return context.watch<UserProvider>().isLoading
        ? Loading(text: "Registrando usuario")
        : Form(
            key: context.watch<UserProvider>().formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Text("Registro de Usuario",
                        style: TextStyle(fontSize: 18)),
                  ),
                  //TIPO USER
                  if (context.watch<UserProvider>().isRegister)
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
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
                                  groupValue:
                                      context.watch<UserProvider>().isEmpresa,
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
                                  groupValue:
                                      context.watch<UserProvider>().isEmpresa,
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
                    ),
                  //NOMBRE
                  CustomFormField(
                    textController:
                        context.watch<UserProvider>().nombreController,
                    typeText: TextInputType.name,
                    textInputAction: TextInputAction.next,
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
                    textStyle: context
                            .watch<UserProvider>()
                            .user
                            .nombreError
                            .toString()
                            .isEmpty
                        ? const TextStyle(color: Colors.white)
                        : const TextStyle(color: Colors.redAccent),
                    validator: (value) => CustomText().isValidName(value!),
                    onChanged: (value) => CustomText().isValidName(value!),
                  ),
                  //NIT
                  if (context.watch<UserProvider>().isEmpresa)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CustomFormField(
                        textController:
                            context.watch<UserProvider>().nitController,
                        typeText: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        hintText: "8956887018",
                        label: const Text("NIT"),
                        helperText: "",
                        icon: const Icon(Icons.numbers),
                        validator: (value) =>
                            CustomText().isValidNumber(value!),
                        onChanged: (value) =>
                            CustomText().isValidNumber(value!),
                      ),
                    ),
                  //RAZON SOCIAL
                  if (context.watch<UserProvider>().isEmpresa)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CustomFormField(
                        textController:
                            context.watch<UserProvider>().razonSocialController,
                        typeText: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        hintText: "Comercial Precio Fijo",
                        label: const Text("Razon Social"),
                        helperText: "",
                        icon: const Icon(CupertinoIcons.person_crop_rectangle),
                        validator: (value) => CustomText().isValidName(value!),
                        onChanged: (value) => CustomText().isValidName(value!),
                      ),
                    ),
                  //context.watch<UserProvider>().isEmpresa ?  : const SizedBox(height: 1),
                  //USERNAME
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CustomFormField(
                      textController:
                          context.watch<UserProvider>().userloginController,
                      typeText: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      label: const Text("User/Nick"),
                      hintText: "perez",
                      helperText: context
                          .watch<UserProvider>()
                          .user
                          .userloginError
                          .toString(),
                      textStyle: context
                              .watch<UserProvider>()
                              .user
                              .userloginError
                              .toString()
                              .isEmpty
                          ? const TextStyle(color: Colors.white)
                          : const TextStyle(color: Colors.redAccent),
                      validator: (value) => CustomText().isValidUserName(value),
                      onChanged: (value) => CustomText().isValidUserName(value),
                      icon: Icon(Icons.login,
                          color: context
                                  .watch<UserProvider>()
                                  .user
                                  .userloginError
                                  .toString()
                                  .isEmpty
                              ? Colors.white
                              : Colors.redAccent),
                    ),
                  ),
                  //EMAIL
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CustomFormField(
                      textController:
                          context.watch<UserProvider>().emailController,
                      icon: Icon(CupertinoIcons.mail,
                          color: context
                                  .watch<UserProvider>()
                                  .user
                                  .emailError
                                  .toString()
                                  .isEmpty
                              ? Colors.white
                              : Colors.redAccent),
                      typeText: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      label: const Text("Email"),
                      hintText: "prueba@gmail.com",
                      helperText: context.watch<UserProvider>().user.emailError,
                      textStyle: context
                              .watch<UserProvider>()
                              .user
                              .emailError
                              .toString()
                              .isEmpty
                          ? const TextStyle(color: Colors.white)
                          : const TextStyle(color: Colors.redAccent),
                      validator: (value) => CustomText().isValidEmail(value),
                      onChanged: (value) => CustomText().isValidEmail(value),
                    ),
                  ),
                  //Password
                  if (context.watch<UserProvider>().isRegister)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CustomFormField(
                        textController:
                            context.watch<UserProvider>().passwordController,
                        icon: const Icon(CupertinoIcons.padlock_solid),
                        typeText: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        label: const Text("Password"),
                        hintText: "password",
                        helperText: "",
                        textStyle: context
                                .watch<UserProvider>()
                                .user
                                .passwordError
                                .toString()
                                .isEmpty
                            ? const TextStyle(color: Colors.white)
                            : const TextStyle(color: Colors.redAccent),
                        obscureText:
                            context.watch<UserProvider>().isObscureText,
                        validator: (value) =>
                            CustomText().isValidPassword(value),
                        onChanged: (value) =>
                            CustomText().isValidPassword(value),
                        viewText: () {
                          context.read<UserProvider>().changeObscureText();
                        },
                      ),
                    ),
                  //Repetir / Password
                  if (context.watch<UserProvider>().isRegister)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CustomFormField(
                        textController: context
                            .watch<UserProvider>()
                            .repeatPasswordController,
                        icon: const Icon(CupertinoIcons.padlock_solid),
                        typeText: TextInputType.text,
                        textInputAction: TextInputAction.send,
                        label: const Text("Repetir Password"),
                        hintText: "password",
                        helperText: "",
                        obscureText:
                            context.watch<UserProvider>().isObscureTextRepeat,
                        validator: (value) {
                          if (CustomText().isValidPasswordRepeat(value) !=
                              null) {
                            return CustomText().isValidPasswordRepeat(value);
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
                          if (CustomText().isValidPasswordRepeat(value) !=
                              null) {
                            return CustomText().isValidPasswordRepeat(value);
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
                    ),
                  //context.watch<UserProvider>().isRegister ?  : const SizedBox(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: FilledButton.tonal(
                        onPressed: () async {
                          context.read<UserProvider>().registerView(context);
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
            ));
  }
}
