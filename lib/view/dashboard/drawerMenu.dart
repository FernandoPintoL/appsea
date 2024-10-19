import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../app/providers/session_provider.dart';
import '../config/pallet.dart';
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: bgColor),
              currentAccountPicture: Container(
                margin: const EdgeInsets.only(bottom: 10),
                height: 70,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/LogoSEA.jpeg'),
                  ),
                ),
              ),
              accountName: Text(
                  context.watch<SessionProvider>().userSession.name,
                  style: TextStyle(overflow: TextOverflow.clip)),
              accountEmail: Text(
                  context.watch<SessionProvider>().userSession.email,
                  style: TextStyle(overflow: TextOverflow.clip))),
          ListTileMenu(
            iconSVG: "assets/icons/home-com.svg",
            title: "Inicio",
            function: () {
              Navigator.pop(context);
              //Navigator.pushNamed(context, "/visitanteview");
              context.read<SessionProvider>().posicionMenu = 0;
            },
            isSelected: context.watch<SessionProvider>().posicionMenu == 0,
          ),
          ListTileMenu(
            iconSVG: "",
            icon:
            Icon(CupertinoIcons.chart_bar_alt_fill, color: Colors.blueGrey),
            title: 'Gestion de Visitas o Ingresos',
            function: () {
              context.read<SessionProvider>().posicionMenu = 3;
              Navigator.pop(context);
              Navigator.pushNamed(context, "/ingresosview");
            },
            isSelected: context.watch<SessionProvider>().posicionMenu == 3,
          ),
          ListTileMenu(
            iconSVG: "assets/icons/logout-com.svg",
            title: 'Cerrar Sessión',
            function: () {
              // context.read<SessionProvider>().posicionMenu = 4;
              context.read<SessionProvider>().logout(context);
            },
            isSelected: false,
          ),
        ],
      ),
    );
  }
}

class ListTileMenu extends StatelessWidget {
  String? iconSVG;
  Icon? icon;
  String? title;
  Function? function;
  bool isSelected;
  ListTileMenu(
      {super.key,
        this.iconSVG,
        this.icon,
        this.title,
        this.function,
        required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      splashColor: Colors.blueGrey.shade600,
      selected: isSelected,
      leading: iconSVG!.isNotEmpty
          ? SvgPicture.asset(
        iconSVG!,
        colorFilter:
        const ColorFilter.mode(Colors.blueGrey, BlendMode.srcIn),
      )
          : icon,
      title: Text(
        title!,
        style: TextStyle(overflow: TextOverflow.clip),
      ),
      onTap: () {
        function!();
      },
    );
  }
}