import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../app/models/ingreso_model.dart';
import '../../app/providers/ingresos_provider.dart';
import '../components/widget/text_descriptivo.dart';
import '../page_gestion/card_list.dart';
import 'control_ingreso_main_page.dart';

class ListIngresos extends StatefulWidget {
  @override
  State<ListIngresos> createState() => _ListIngresosState();
}

class _ListIngresosState extends State<ListIngresos> {
  FocusNode focusDetalleSalidaIngreso = FocusNode();
  ScrollController scrollController = ScrollController();

  Future refresh() async {
    if (!context.read<IngresosProvider>().isScrolleable) return;
    context.read<IngresosProvider>().queryListRange();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        refresh();
      }
    });
  }

  @override
  void dispose() {
    focusDetalleSalidaIngreso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        itemCount: context.watch<IngresosProvider>().lista.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < context.read<IngresosProvider>().lista.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(25),
                    shape: BoxShape.rectangle),
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 7.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("ID: ${context.watch<IngresosProvider>().lista[index].id}",
                            style: const TextStyle(
                                overflow: TextOverflow.visible, fontWeight: FontWeight.bold)),
                        Flexible(
                          child: Text(
                            context.watch<IngresosProvider>().lista[index].isAutorizado
                                ? "Ingreso autorizado".toUpperCase()
                                : "Ingreso no autorizado".toUpperCase(),
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.barlow(
                                color: context.watch<IngresosProvider>().lista[index].isAutorizado
                                    ? Colors.green
                                    : Colors.redAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    CardList(
                      contentPadding: 0,
                      isDecoration: false,
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDescriptivo(
                              title: "Res.: ",
                              subtitle: context.watch<IngresosProvider>().lista[index].residente.perfil.nombre),
                          TextDescriptivo(
                              title: "Vivienda: ",
                              subtitle: context.watch<IngresosProvider>().lista[index].residente.vivienda.nroVivienda),
                          TextDescriptivo(
                              title: "Visitante: ",
                              subtitle: context.watch<IngresosProvider>().lista[index].visitante.perfil.nombre),
                          if (context.watch<IngresosProvider>().lista[index].detalle!.isNotEmpty)
                            TextDescriptivo(
                                title: "Detalle: ",
                                subtitle: context.watch<IngresosProvider>().lista[index].detalle.toString()),
                          if (context.watch<IngresosProvider>().lista[index].detalleSalida!.isNotEmpty)
                            TextDescriptivo(
                                title: "Detalle Salida: ",
                                subtitle: context.watch<IngresosProvider>().lista[index].detalleSalida.toString()),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                context.watch<IngresosProvider>().lista[index].vehiculo_id == 0
                                    ? Icons.directions_walk_sharp
                                    : CupertinoIcons.car_detailed,
                                color: context.watch<IngresosProvider>().lista[index].vehiculo_id == 0
                                    ? Colors.blueGrey
                                    : Colors.indigoAccent,
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    context.watch<IngresosProvider>().lista[index].vehiculo_id == 0
                                        ? "Ingreso sin Vehiculo".toUpperCase()
                                        : "Ingreso con vehiculo".toUpperCase(),
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.teko(
                                        color: context.watch<IngresosProvider>().lista[index].vehiculo_id == 0
                                            ? Colors.blueGrey
                                            : Colors.indigoAccent),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: null,
                      trailing: context.watch<IngresosProvider>().lista[index].isAutorizado &&
                              (context.watch<IngresosProvider>().lista[index].salida_created_at == null ||
                                  context.watch<IngresosProvider>().lista[index].salida_created_at!.isEmpty)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.indigoAccent,
                                  child: IconButton(
                                    highlightColor: Colors.orange,
                                    style: ButtonStyle(
                                      elevation: WidgetStateProperty.all<double>(10.0),
                                      backgroundColor: WidgetStateProperty.all<Color>(Colors.indigoAccent),
                                      shadowColor: WidgetStateProperty.all<Color?>(Colors.blueGrey.shade100),
                                    ),
                                    onPressed: () {
                                      registerSalida(context, context.read<IngresosProvider>().lista[index]);
                                    },
                                    icon: const Icon(
                                      Icons.output_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    "Registrar Salida",
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.teko(color: Colors.indigoAccent),
                                  ),
                                )
                              ],
                            )
                          : CircleAvatar(
                              backgroundColor: context.watch<IngresosProvider>().lista[index].isAutorizado &&
                                      (context.watch<IngresosProvider>().lista[index].salida_created_at != null ||
                                          context.watch<IngresosProvider>().lista[index].salida_created_at!.isNotEmpty)
                                  ? Colors.green.shade400
                                  : Colors.redAccent,
                              child: Icon(
                                  context.watch<IngresosProvider>().lista[index].isAutorizado &&
                                          (context.watch<IngresosProvider>().lista[index].salida_created_at != null ||
                                              context
                                                  .watch<IngresosProvider>()
                                                  .lista[index]
                                                  .salida_created_at!
                                                  .isNotEmpty)
                                      ? Icons.check_circle_outline
                                      : CupertinoIcons.shield_slash,
                                  color: Colors.white),
                            ),
                      colorTrailing: Colors.green.shade400,
                      isSelectTrailing: false,
                      isRequiredTrailing: false,
                      function: (){

                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Ingreso: ${context.watch<IngresosProvider>().lista[index].created_at!}".toUpperCase(),
                          overflow: TextOverflow.visible,
                          style: GoogleFonts.barlowCondensed( color: Colors.blueGrey),
                        ),
                        if (context.watch<IngresosProvider>().lista[index].isAutorizado)
                          Text(
                              context.watch<IngresosProvider>().lista[index].salida_created_at == null ||
                                      context.watch<IngresosProvider>().lista[index].salida_created_at!.isEmpty
                                  ? "SALIDA NO REGISTRADA"
                                  : "SALIDA: ${context.watch<IngresosProvider>().lista[index].salida_created_at!}",
                              overflow: TextOverflow.visible,
                              style: GoogleFonts.barlowCondensed(
                                color: context.watch<IngresosProvider>().lista[index].salida_created_at == null ||
                                        context.watch<IngresosProvider>().lista[index].salida_created_at!.isEmpty
                                    ? Colors.redAccent
                                    : Colors.green,
                              ))
                      ],
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: context.watch<IngresosProvider>().hasMore
                    ? const CircularProgressIndicator()
                    : const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.info),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "NO HAY MAS DATOS",
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }
        });
  }

  Future<void> registerSalida(BuildContext context, Ingreso ingreso) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              width: double.infinity,
              height: (MediaQuery.of(context).size.height / 2) - 100,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "¿Deseas registrar la salida?",
                    style: TextStyle(fontSize: 20, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      minLines: 3,
                      maxLines: 26,
                      controller: context.watch<IngresosProvider>().detalleSalidaController,
                      focusNode: focusDetalleSalidaIngreso,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.send,
                      onTapOutside: (event) {
                        focusDetalleSalidaIngreso.unfocus();
                      },
                      decoration: const InputDecoration(
                          labelText: "Detalle para el salida", icon: Icon(CupertinoIcons.captions_bubble)),
                    ),
                  ),
                  context.watch<IngresosProvider>().isLoading
                      ? const Center(child: Text("Cargando..."))
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.redAccent)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancelar',
                                  style: TextStyle(color: Colors.white, overflow: TextOverflow.clip)),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                              ),
                              onPressed: () {
                                context.read<IngresosProvider>().registrarSalidaVisitante(context, ingreso.id);
                                Navigator.pop(context);
                              },
                              child: const Text('OK', style: TextStyle(color: Colors.white, overflow: TextOverflow.clip)),
                            )
                          ],
                        )
                ],
              ),
            ),
          );
        });
  }
}
