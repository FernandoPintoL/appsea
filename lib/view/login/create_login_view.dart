import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../app/providers/session_provider.dart';
import '../components/metodos/CustomTextFormField.dart';
import '../config/constants.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
  final GlobalKey<ScaffoldState> scaffoldkeyCreate = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          key: scaffoldkeyCreate,
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return _buildLargeScreen(size, theme);
              } else {
                return _buildSmallScreen(size, theme);
              }
            },
          )),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(Size size, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.asset(
              'assets/js/coin.json',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(Size size, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(Size size, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: size.width > 600
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          size.width > 600
              ? Container()
              : Lottie.asset(
                  'assets/js/wave.json',
                  height: size.height * 0.2,
                  width: size.width,
                  fit: BoxFit.fill,
                ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Inscribete',
              style: kLoginTitleStyle(size),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              'Crea tu cuenta',
              style: kLoginSubtitleStyle(size),
            ),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Form(
              key: context.read<SessionProvider>().formKeyCreate,
              child: SingleChildScrollView(
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    /// nombre completo
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          label: const Text("Nombre"),
                          prefixIcon: const Icon(Icons.person),
                          hintText: 'Nombre',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          errorText: context.watch<SessionProvider>().isSubmit
                              ? context.watch<SessionProvider>().nameError
                              : null),
                      controller:
                          context.watch<SessionProvider>().nameController,
                      // The validator receives the text that the user has entered.
                      /*validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Porfavor ingrese tu nombre completo';
                        } else if (value.length < 4) {
                          return 'al menos ingresa 4 caracteres';
                        }
                        return null;
                      },*/
                      validator: (value) => CustomText().isValidName(value!),
                      //onChanged: (value) => CustomText().isValidName(value!),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// username
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          label: const Text("UserNick"),
                          prefixIcon: const Icon(Icons.person),
                          hintText: 'UserNick',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          errorText: context.watch<SessionProvider>().isSubmit
                              ? context.watch<SessionProvider>().nickError
                              : null),

                      controller:
                          context.watch<SessionProvider>().nickController,
                      // The validator receives the text that the user has entered.
                      /*validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Porfavor ingrese un usernick';
                        } else if (value.length < 4) {
                          return 'al menos ingresa 4 caracteres';
                        } else if (value.length > 13) {
                          return 'el carácter máximo es 13';
                        }
                        return null;
                      },*/
                      validator: (value) =>
                          CustomText().isValidUserName(value!),
                      //onChanged: (value) => CustomText().isValidUserName(value!),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// Gmail
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller:
                          context.watch<SessionProvider>().emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          label: const Text("Email"),
                          prefixIcon: const Icon(Icons.email_rounded),
                          hintText: 'gmail',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          errorText: context.watch<SessionProvider>().isSubmit
                              ? context.watch<SessionProvider>().emailError
                              : null),
                      // The validator receives the text that the user has entered.
                      /*validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Porfavor ingresa gmail';
                        } else if (!value.endsWith('@gmail.com')) {
                          return 'porfavor ingresa gmail valido';
                        }
                        return null;
                      },*/
                      validator: (value) => CustomText().isValidEmail(value!),
                      //onChanged: (value) => CustomText().isValidEmail(value!),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// password
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller:
                          context.watch<SessionProvider>().passwordController,
                      obscureText:
                          context.watch<SessionProvider>().passwordInput,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        prefixIcon: const Icon(Icons.lock_open),
                        errorText: context.watch<SessionProvider>().isSubmit
                            ? context.watch<SessionProvider>().passwordError
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            context.watch<SessionProvider>().passwordInput
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            //simpleUIController.isObscureActive();
                            context.read<SessionProvider>().changePassword();
                          },
                        ),
                        hintText: 'Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      /*validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Porfavor ingresa algun texto';
                        } else if (value.length < 7) {
                          return 'al menos ingresa 6 caracteres';
                        } else if (value.length > 13) {
                          return 'el carácter máximo es 13';
                        }
                        return null;
                      },*/
                      validator: (value) =>
                          CustomText().isValidPassword(value!),
                      //onChanged: (value) => CustomText().isValidPassword(value!),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// password confirmation
                    TextFormField(
                      style: kTextFormFieldStyle(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: context
                          .watch<SessionProvider>()
                          .passwordConfirmationController,
                      obscureText: context
                          .watch<SessionProvider>()
                          .passwordConfirmacionInput,
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: (value) {
                        print(value.toString());
                        context.read<SessionProvider>().registerUser(context);
                      },
                      decoration: InputDecoration(
                        label: const Text("Password Confirmación"),
                        prefixIcon: const Icon(Icons.lock_open),
                        errorText: context.watch<SessionProvider>().isSubmit
                            ? context
                                .watch<SessionProvider>()
                                .passwordConfirmationError
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            context
                                    .watch<SessionProvider>()
                                    .passwordConfirmacionInput
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            //simpleUIController.isObscureActive();
                            context
                                .read<SessionProvider>()
                                .changePasswordConfirmacion();
                          },
                        ),
                        hintText: 'Password Confirmación',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      /*validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Porfavor ingresa algun texto';
                        } else if (value.length < 7) {
                          return 'al menos ingresa 6 caracteres';
                        } else if (value.length > 13) {
                          return 'el carácter máximo es 13';
                        }
                        return null;
                      },*/
                      validator: (value) {
                        if (value !=
                            context
                                .read<SessionProvider>()
                                .passwordController
                                .text) {
                          return "Las contraseñas no coinciden";
                        }
                        return null;
                      },
                      //onChanged: (value) => CustomText().isValidPasswordRepeat(value!),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                            hoverColor: Colors.green[200],
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                            value: context.watch<SessionProvider>().terms,
                            onChanged: (value) {
                              context.read<SessionProvider>().changeTerms();
                            }),
                        Expanded(
                          child: Text(
                            'Estoy de acuerdo con los términos y condiciones de uso',
                            style: kLoginTermsAndPrivacyStyle(size),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),

                    /// SignUp Button
                    signUpButton(theme),
                    SizedBox(
                      height: size.height * 0.03,
                    ),

                    /// Navigate To Login Screen
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Ya tienes una cuenta?',
                          style: kHaveAnAccountStyle(size),
                          children: [
                            TextSpan(
                                text: " Inicia Sesión",
                                style: kLoginOrSignUpTextStyle(size)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () {
          print("precessando");
          context.read<SessionProvider>().registerUser(context);
        },
        child: const Text('Inscribete',
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
