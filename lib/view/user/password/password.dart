import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/providers/user_provider.dart';
import '../../components/metodos/CustomTextFormField.dart';
import '../../components/responsive.dart';
import '../../components/widget/customTextFormField.dart';
import '../../components/widget/dialog.dart';
import '../../config/pallet.dart';

//FORMULARIOS DE CAMBIO DE CONTRASEÑA
class FormViewPassword extends StatefulWidget {
  const FormViewPassword({super.key});

  @override
  State<FormViewPassword> createState() => _FormViewPasswordState();
}

class _FormViewPasswordState extends State<FormViewPassword> {
  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: const Padding(
          padding: EdgeInsets.all(16.0),
          child: FormPassword(),
        ),
        desktop: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25, vertical: 16),
          child: const FormPassword(),
        )
    );
  }
}

class FormPassword extends StatefulWidget {
  const FormPassword({super.key});

  @override
  State<FormPassword> createState() => _FormPasswordState();
}

class _FormPasswordState extends State<FormPassword> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: context.read<UserProvider>().formPasswordKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Text("Modificar contraseña", style: TextStyle(fontSize: 18)),
            ),
            //Password
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomFormField(
                textController: context.watch<UserProvider>().passwordController,
                icon: const Icon(CupertinoIcons.padlock_solid),
                typeText: TextInputType.text,
                hintText: "Contraseña anterior: ",
                helperText: "",
                obscureText: context.watch<UserProvider>().isObscureText,
                validator: (value) => CustomText().isValidPassword(value),
                onChanged: (value) => CustomText().isValidPassword(value),
                viewText: (){
                  context.read<UserProvider>().changeObscureText();
                },
              ),
            ),
            //NUEVA PASSWORD
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomFormField(
                textController: context.watch<UserProvider>().newPasswordController,
                icon: const Icon(CupertinoIcons.padlock_solid),
                typeText: TextInputType.text,
                hintText: "Contraseña Nueva: ",
                helperText: "",
                obscureText: context.watch<UserProvider>().isObscureTextNew,
                validator: (value) => CustomText().isValidPassword(value),
                onChanged: (value) => CustomText().isValidPassword(value),
                viewText: (){
                  context.read<UserProvider>().changeObscureTextNew();
                },
              ),
            ),
            //Repetir / Password
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomFormField(
                textController: context.watch<UserProvider>().repeatPasswordController,
                icon: const Icon(CupertinoIcons.padlock_solid),
                typeText: TextInputType.text,
                hintText: "Repetir Contraseña: ",
                helperText: "",
                obscureText: context.watch<UserProvider>().isObscureTextRepeat,
                validator: (value) {
                  if(CustomText().isValidPasswordRepeat(value) != null){
                    return CustomText().isValidPasswordRepeat(value);
                  }else if(context.read<UserProvider>().repeatPasswordController.text != context.read<UserProvider>().newPasswordController.text){
                    return "Los campos son distintos";
                  }
                  return null;
                },
                onChanged: (value) {
                  if(CustomText().isValidPasswordRepeat(value) != null){
                    return CustomText().isValidPasswordRepeat(value);
                  }else if(context.read<UserProvider>().repeatPasswordController.text != context.read<UserProvider>().newPasswordController.text){
                    return "Los campos son distintos";
                  }
                  return null;
                },
                viewText: (){
                  context.read<UserProvider>().changeObscureTextRepeat();
                },
              ),
            ),
            //BOTON
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child:  FilledButton.tonal(
                  onPressed: () async {
                    if(context.read<UserProvider>().formPasswordKey.currentState!.validate()){
                      DialogMessage.dialog(context,
                          DialogType.question,
                          "Estas seguro de actualizar la contraseña",
                          "",
                              () async {
                            context.read<UserProvider>().formPasswordKey.currentState!.save();
                            //llamar al metodo actualizar contraseña
                            context.read<UserProvider>().changePassword(context);
                            //Provider.of<UserProvider>(context, listen: false).changePassword(context);
                          });
                    }
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          style: TextStyle(
                              fontSize: 16
                          ),
                          text: "Modificar",
                        ),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(CupertinoIcons.person_2_square_stack),
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}