import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../metodos/UpperCaseTextFormatter.dart';

class CustomFormField extends StatelessWidget {
  CustomFormField(
      {super.key,
      this.textController,
      required this.hintText,
      this.helperText = "",
      this.errorText,
      required this.typeText,
      this.validator,
      this.onChanged,
      this.icon = const Icon(CupertinoIcons.question_circle),
      this.obscureText = false,
      this.viewText,
      this.label,
      this.textStyle = null,
      this.textInputAction = TextInputAction.none,
      this.focusNode,
      this.inputFormatters,
      this.onEditComplete = null,
      this.onTapOutside = null});

  final TextEditingController? textController;
  final String hintText;
  String? errorText;
  String helperText = "";
  TextInputType typeText;
  String? Function(String?)? validator;
  String? Function(String?)? onChanged;
  Widget? icon;
  bool obscureText;
  Function? viewText;
  Widget? label;
  TextStyle? textStyle;
  TextInputAction textInputAction;
  FocusNode? focusNode;
  List<TextInputFormatter>? inputFormatters;
  Function(PointerDownEvent)? onTapOutside;
  Function()? onEditComplete;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: typeText,
      controller: textController,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText,
      enableSuggestions: true,
      onTapOutside: onTapOutside,
      cursorColor: Colors.blue,
      inputFormatters: [
        UpperCaseTextFormatter(),
      ],
      /*onTapOutside: (event) {
        print("onTapOutside");
        print(event);
        if (focusNode == null) {
          focusNode = FocusNode();
          focusNode!.unfocus();
        } else {
          focusNode!.unfocus();
        }
      },*/
      onEditingComplete: onEditComplete,
      // style: textStyle,
      decoration: InputDecoration(
          label: label,
          labelStyle: textStyle != null ? textStyle : TextStyle(fontWeight: FontWeight.bold),
          hintText: hintText,
          errorText: errorText,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent, width: 0.0),
          ),
          helperText: helperText,
          // helperStyle: const TextStyle(color: Colors.redAccent),
          prefixIcon: icon,
          suffixIcon: viewText != null
              ? IconButton(
                  tooltip: "Ver password",
                  hoverColor: Colors.blueGrey,
                  onPressed: () {
                    viewText!();
                  },
                  icon: const Icon(Icons.remove_red_eye_outlined))
              : null),
    );
  }
}
