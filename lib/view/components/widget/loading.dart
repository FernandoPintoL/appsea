import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Loading extends StatelessWidget {
  String text;

  Loading({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/LogoSEA.jpeg'),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const SpinKitWaveSpinner(
              color: Colors.white,
              size: 100.0,
              duration: Duration(milliseconds: 1200),
            ),
            const SizedBox(height: 15),
            Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: GoogleFonts.handjet(fontSize: 14.5, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
