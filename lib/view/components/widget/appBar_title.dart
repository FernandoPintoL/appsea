import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarTitle extends StatelessWidget {
  String title;
  double size;
  AppBarTitle({super.key, required this.title, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: TextAlign.center,
        style: GoogleFonts.chakraPetch(
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.clip),
        ));
  }
}
