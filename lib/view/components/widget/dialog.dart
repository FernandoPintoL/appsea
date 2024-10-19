import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class DialogMessage {
  static void dialog(BuildContext context, DialogType type, String title,
      String desc, Function btnOk) async {
    AwesomeDialog(
      context: context,
      /*width: Responsive.isMobile(context)
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width * 0.5,*/
//      **width: MediaQuery.of(context).size.width,
      dialogType: type,
      animType: AnimType.bottomSlide,
      title: title.toUpperCase(),
      desc: desc.toUpperCase(),
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        btnOk();
      },
    ).show();
  }

  void dialogInfo(BuildContext context, String title, String desc) {
    AwesomeDialog(
      context: context,
      //width: Responsive.isMobile(context) ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width * 0.5,
      // width: MediaQuery.of(context).size.width,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: title.toUpperCase(),
      desc: desc.toUpperCase(),
      btnOkOnPress: () {},
    ).show();
  }

  void alertDialog(BuildContext context, String title, String content,
      VoidCallback continueCallBack) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlurryDialog(title, content, continueCallBack);
      },
    );
  }

  void snackBar(
      BuildContext context, String title, String description, Color color) {
    final snackBar = SnackBar(
      showCloseIcon: true,
      backgroundColor: color,
      closeIconColor: Colors.white,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(CupertinoIcons.info_circle, color: Colors.white),
              ),
              Flexible(
                child: Text(title.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Text(description,
              style: TextStyle(
                  color: Colors.white,
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.w300)),
        ],
      ),
      /*action: SnackBarAction(
        backgroundColor: Colors.blueGrey.shade300,
        textColor: Colors.white,
        label: "OK",
        onPressed: () {
          // Some code to undo the change.
        },
      ),*/
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class BlurryDialog extends StatelessWidget {
  String title;
  String content;
  VoidCallback continueCallBack;

  BlurryDialog(this.title, this.content, this.continueCallBack, {super.key});

  TextStyle textStyle = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          title: Text(
            title,
            //style: textStyle,
          ),
          content: Text(
            content,
            //style: textStyle,
          ),
          actions: <Widget>[
            MaterialButton(
              child: const Text("Continuar"),
              onPressed: () async {
                Navigator.of(context).pop();
                continueCallBack();
              },
            ),
            MaterialButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
