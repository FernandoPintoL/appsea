import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  Widget? title;
  Widget? subtitle;
  Widget? leading;
  Widget? trailing;
  Function? function;
  bool isRequiredTrailing;
  Function? functionTrailing;
  Icon? iconTrailing;
  bool isSelectTrailing;
  Color? colorTrailing;
  bool selected;
  Decoration? decoration;
  bool isDecoration;
  double contentPadding;

  CardList(
      {super.key,
      this.title = null,
      this.subtitle = null,
      this.leading = null,
      this.trailing = null,
      this.function,
      required this.isRequiredTrailing,
      this.functionTrailing,
      this.iconTrailing,
      this.colorTrailing,
      this.selected = false,
      this.isSelectTrailing = false,
      this.decoration = null,
      this.isDecoration = true,
      this.contentPadding = 5});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 4.0),
      decoration: this.isDecoration
          ? BoxDecoration(
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(25),
              shape: BoxShape.rectangle)
          : null,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: contentPadding, vertical: 0),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        /*selected: true,
        selectedColor: Colors.green,*/
        splashColor: Colors.deepOrangeAccent,
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: () {
          function!();
        },
      ),
    );
  }
}