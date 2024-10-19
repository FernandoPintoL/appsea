import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../metodos/UpperCaseTextFormatter.dart';

class BuscadorTextField extends StatelessWidget {
  TextEditingController queryController;
  Function ejecutar;
  Function refrescar;
  String label;
  String couterText;
  FocusNode focusNode;
  bool isIconRequired;

  BuscadorTextField(
      {super.key,
      required this.queryController,
      required this.focusNode,
      required this.ejecutar,
      required this.refrescar,
      required this.label,
      this.isIconRequired = true,
      this.couterText = ""});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      inputFormatters: [
        UpperCaseTextFormatter(),
      ],
      textInputAction: TextInputAction.search,
      enableSuggestions: true,
      controller: queryController,
      focusNode: focusNode,
      onTapOutside: (event) {
        focusNode.unfocus();
      },

      /*onEditingComplete: () {
        focusNode.unfocus();
      },*/
      onChanged: (value) {
        if (value.isNotEmpty) {
          //context.read<UserProvider>().consultando(context);
          ejecutar();
        }
      },
      onFieldSubmitted: (value) async {
        print("campo enviado");
        ejecutar();
        focusNode.unfocus();
      },
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          suffixIcon: IconButton(
              style: ButtonStyle(
                // shadowColor: WidgetStateProperty.all<Color>(Colors.grey),
                // backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey),
                elevation: WidgetStateProperty.all<double>(8),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              onPressed: () {
                ejecutar();
              },
              icon: const Icon(
                CupertinoIcons.search
              )),
          hintText: label,
          counterText: couterText,
          counterStyle: const TextStyle(fontSize: 7.0),
          label: Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              overflow: TextOverflow.clip,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
