import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/providers/residentes_providers.dart';
import '../components/widget/appBar_title.dart';
import '../page_gestion/page_gestion.dart';
import 'list_residentes.dart';

class ResidentesView extends StatefulWidget {
  const ResidentesView({super.key});

  @override
  State<ResidentesView> createState() => _ResidentesViewState();
}

class _ResidentesViewState extends State<ResidentesView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late FocusNode focusQuery;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusQuery = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    focusQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: context.read<ResidentesProvider>().scaffoldkeyResidentes,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        title: AppBarTitle(title: context.read<ResidentesProvider>().textAppBar.toUpperCase()),
        actions: [
          IconButton(
              style: ButtonStyle(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  shadowColor: WidgetStateProperty.all<Color>(Colors.blueGrey.shade400),
                  // backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey),
                  elevation: WidgetStateProperty.all<double>(9.0)),
              tooltip: "RECARGAR RESIDENTES",
              onPressed: () async {
                // context.read<ResidentesProvider>().queryList("");
                // counterText = "";
                context.read<ResidentesProvider>().changeLoading(true, "CARGANDO PAGINA");
                context.read<ResidentesProvider>().clearList();
                await context.read<ResidentesProvider>().queryListRange();
                if(!context.mounted) return;
                context.read<ResidentesProvider>().changeLoading(false, "");
              },
              icon: const Icon(
                CupertinoIcons.refresh_thick,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
        child: PageGestion(
          isLoading: context.watch<ResidentesProvider>().isLoading,
          textLoading: context.watch<ResidentesProvider>().textLoading,
          label: "Buscador de Residentes",
          queryController: context.watch<ResidentesProvider>().queryController,
          focusNode: focusQuery,
          httpResponsse: context.watch<ResidentesProvider>().httpResponsse,
          listado: context.watch<ResidentesProvider>().lista,
          isListEmpty: context.watch<ResidentesProvider>().lista.isEmpty,
          isIconRequired: false,
          functionBuscar: () {
            ///COLOCAR EL METODO DE BUSQUEDA
            print("busqueda input box");
            context.read<ResidentesProvider>().queryList();
          },
          refrescarPagina: () async {
            ///RECARGAR LA PAGINA
            // context.read<ResidentesProvider>().queryList("");
            context.read<ResidentesProvider>().changeLoading(true, "CARGANDO PAGINA");
            context.read<ResidentesProvider>().clearList();
            await context.read<ResidentesProvider>().queryListRange();
            if(!context.mounted) return;
            context.read<ResidentesProvider>().changeLoading(false, "");
          },
          registrarNuevo: () {},
          listadoWidget: ListResidentes(),
        ),
      ),
    );
  }
}
