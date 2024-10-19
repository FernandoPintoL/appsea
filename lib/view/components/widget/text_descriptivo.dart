import 'package:flutter/material.dart';

class TextDescriptivo extends StatelessWidget {
  TextDescriptivo({required this.title, required this.subtitle, super.key});
  String title;
  String subtitle;
  @override
  Widget build(BuildContext context) {
    return RichText(
      overflow: TextOverflow.visible,
      softWrap: false,
      text: TextSpan(
        text: title.toUpperCase(),
        style: DefaultTextStyle.of(context).style.copyWith(
            fontWeight: FontWeight.w300,
            overflow: TextOverflow.visible,
        ),
        children: <TextSpan>[
          TextSpan(
              text: subtitle.toUpperCase(),
              style: const TextStyle(
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
