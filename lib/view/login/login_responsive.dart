import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../app/providers/session_provider.dart';
import '../components/metodos/CustomTextFormField.dart';
import '../config/constants.dart';
import '../config/lang/es.dart';

class LoginResponsive extends StatefulWidget {
  const LoginResponsive({super.key});
  @override
  State<LoginResponsive> createState() => _LoginResponsiveState();
}

class _LoginResponsiveState extends State<LoginResponsive> {
  // final GlobalKey<ScaffoldState> scaffoldkeyLogin = GlobalKey<ScaffoldState>();
  late FocusNode focusEmail;
  late FocusNode focusPassword;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusEmail = FocusNode();
    focusPassword = FocusNode();
  }

  @override
  void dispose() {
    focusEmail.dispose();
    focusPassword.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: context.read<SessionProvider>().scaffoldkeyLogin,
        //backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Lottie.asset(
              'assets/js/wave.json',
              height: size.height * 0.2,
              width: size.width,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                login_iniciar.toString(),
                style: kLoginTitleStyle(size)
                    .copyWith(overflow: TextOverflow.clip, wordSpacing: 2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                textAlign: TextAlign.center,
                bienvenido + title_general,
                style: kLoginSubtitleStyle(size).copyWith(wordSpacing: 5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Form(
                    key: context.read<SessionProvider>().formKeyLogin,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          /// username or Gmail
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: TextFormField(
                              // style: kTextFormFieldStyle(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email),
                                label: Text(username_login,
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400)),
                                hintText: username_login,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                errorText: context
                                    .watch<SessionProvider>().nameError
                              ),
                              controller: context
                                  .watch<SessionProvider>()
                                  .loginNickController,
                              focusNode: focusEmail,
                              onTapOutside: (event){
                                focusEmail.unfocus();
                              },
                              validator: (value) => CustomText().isValidEmail(value),
                            ),
                          ),

                          /// password
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              // style: kTextFormFieldStyle(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              textInputAction: TextInputAction.send,
                              controller: context
                                  .watch<SessionProvider>()
                                  .loginPasswordController,
                              focusNode: focusPassword,
                              onTapOutside: (event){
                                focusPassword.unfocus();
                              },
                              obscureText: context
                                  .watch<SessionProvider>()
                                  .loginPasswordInput,
                              decoration: InputDecoration(
                                label: Text(password_login,
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400)),
                                prefixIcon: const Icon(Icons.lock_open),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    context
                                            .watch<SessionProvider>()
                                            .loginPasswordInput
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<SessionProvider>()
                                        .changeLoginPassword();
                                  },
                                ),
                                hintText: password_login,
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                  errorText: context
                                      .watch<SessionProvider>().passwordError
                              ),
                              // The validator receives the text that the user has entered.
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return validator_empety;
                                } else if (value.length < 6) {
                                  return validator_min6_length;
                                }
                                return null;
                              },
                            ),
                          ),

                          /// Login Button
                          Padding(
                            padding: const EdgeInsets.only(top: 28.0),
                            child: loginButton(),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          if(context.watch<SessionProvider>().isLoading)
                            Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(context.watch<SessionProvider>().textLoading),
                              const SizedBox(height: 15,),
                              const SpinKitWaveSpinner(
                                color: Colors.white,
                                size: 100.0,
                                duration: Duration(milliseconds: 1200),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Login Button
  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.deepPurpleAccent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async {
          await context.read<SessionProvider>().login(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              iniciar.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.login, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
