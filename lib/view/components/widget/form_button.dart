import 'package:flutter/material.dart';

class FormButtom extends StatelessWidget {
  Function ejecutar;
  String title;
  Widget icon;
  bool isSearch;
  bool isRegister;
  Color color;

  FormButtom(
      {super.key,
      required this.ejecutar,
      required this.title,
      required this.icon,
      this.isRegister = false,
      this.isSearch = true,
      this.color = Colors.blueGrey});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: ButtonStyle(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          backgroundColor: WidgetStatePropertyAll<Color>(color)),
      onPressed: () {
        ejecutar();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title.toUpperCase(),
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          icon
        ],
      ),
    );
  }
}
