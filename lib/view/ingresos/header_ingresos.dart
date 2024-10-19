import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sea/view/components/widget/text_image.dart';
import 'package:sea/view/components/widget/widgets_styles.dart';
import '../../app/providers/ingresos_provider.dart';
import '../../app/providers/vehiculo_provider.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/metodos/call_whtas.dart';
import 'upload_image_visit_car.dart';

class HeaderIngresos extends StatelessWidget {
  const HeaderIngresos({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: 90,
      // padding: EdgeInsets.only(top: 0, bottom: 8, left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(child: Text("Datos Seleccionados".toUpperCase(), style: WidgetStyles().textStyleTitle())),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (context.read<IngresosProvider>().model.residente.perfil.celular.isNotEmpty)
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // WHATSSAP
                            IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.white,
                              ),
                              color: Colors.green,
                              style: ButtonStyle(
                                  elevation: WidgetStateProperty.all<double>(8),
                                  shadowColor: WidgetStateProperty.all<Color>(Colors.blueGrey.shade100),
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                              onPressed: () {
                                if (context.read<IngresosProvider>().model.residente.perfil.celular.isNotEmpty) {
                                  const String prefix = "+591";
                                  Calls().sendWhats(
                                      phone: prefix +
                                          context.read<IngresosProvider>().model.residente.perfil.celular,
                                      text: "");
                                } else {}
                              },
                            ),
                            //LLAMDA
                            IconButton(
                              icon: const Icon(FontAwesomeIcons.phone),
                              style: ButtonStyle(
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  elevation: WidgetStateProperty.all<double>(8),
                                  shadowColor: WidgetStateProperty.all<Color>(Colors.blueGrey.shade100),
                                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey)),
                              onPressed: () {
                                if (context.read<IngresosProvider>().model.residente.perfil.celular.isNotEmpty) {
                                  Calls().makePhoneCall(
                                      context.read<IngresosProvider>().model.residente.perfil.celular);
                                }
                              },
                            ),
                          ]),
                    if ((context.watch<IngresosProvider>().isRegisterVisitante ||
                            context.watch<IngresosProvider>().isRegisterVehiculo) &&
                        (context.watch<IngresosProvider>().isRegister))
                      //GALERIAS
                      IconButton(
                          style: ButtonStyle(
                              visualDensity: VisualDensity.adaptivePlatformDensity,
                              elevation: WidgetStateProperty.all<double>(8),
                              shadowColor: WidgetStateProperty.all<Color>(Colors.orange.shade100),
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.orange)),
                          onPressed: () {
                            if (context.read<IngresosProvider>().isRegisterVisitante) {
                              context
                                  .read<VisitanteProvider>()
                                  .cargarGaleriaVisitantes(context.read<IngresosProvider>().model.visitante_id);
                            }
                            if (context.read<IngresosProvider>().isRegisterVehiculo) {
                              context
                                  .read<VehiculoProvider>()
                                  .cargarGaleriaVehiculo(context.read<IngresosProvider>().model.vehiculo_id);
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UploadImageVisitCar()),
                            );
                          },
                          icon: const Icon(
                            CupertinoIcons.camera,
                            color: Colors.white,
                          ))
                  ],
                ),
              ],
            ),
          ),
          // RESIDENTE
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Res.: ".toUpperCase(), style: WidgetStyles().textStyleTitleResVeh()),
              Flexible(
                child: Text(
                    "${context.read<IngresosProvider>().model.residente.perfil.nombre} / ${context.read<IngresosProvider>().model.residente.vivienda.nroVivienda}",
                    style: WidgetStyles().textStyleContenidoResVeh()),
              ),
            ],
          ),
          // VISITANTE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (context.watch<IngresosProvider>().isRegisterVisitante)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Visitante: ".toUpperCase(), style: WidgetStyles().textStyleTitleResVeh()),
                        Flexible(
                          child: Text(
                              "${context.read<IngresosProvider>().model.visitante.perfil.nombre.toUpperCase()} / ${context.read<IngresosProvider>().model.visitante.perfil.nroDocumento}",
                              maxLines: 2,
                              style: WidgetStyles().textStyleContenidoResVeh()),
                        ),
                      ],
                    ),
                    if (context.read<IngresosProvider>().isRegister &&
                        context.read<IngresosProvider>().isRegisterVisitante)
                      TextImage(
                          message:
                              "${context.watch<VisitanteProvider>().listImagenes.length} ITEMS EN GALERIA DEL VISITANTE",
                          isLoading: context.watch<VisitanteProvider>().isLoadingGaleria)
                  ],
                ),
              if (context.watch<IngresosProvider>().isRegisterVehiculo &&
                  context.watch<IngresosProvider>().model.vehiculo_id != 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("PLACA: ".toUpperCase(), style: WidgetStyles().textStyleTitleResVeh()),
                        Flexible(
                          child: Text(
                              "${context.read<IngresosProvider>().model.vehiculo.placa} / ${context.read<IngresosProvider>().model.vehiculo.tipo_vehiculo.toUpperCase()}",
                              style: WidgetStyles().textStyleContenidoResVeh()),
                        ),
                      ],
                    ),
                    if (context.read<IngresosProvider>().isRegister &&
                        context.read<IngresosProvider>().isRegisterVehiculo)
                      TextImage(
                          message:
                          "${context.watch<VehiculoProvider>().listImagenes.length} ITEMS EN GALERIA DEL VEHICULO",
                          isLoading: context.watch<VehiculoProvider>().isLoadingGaleria)
                  ],
                ),
            ],
          ),
          if (context.watch<IngresosProvider>().isRegisterVisitante)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  context.watch<IngresosProvider>().ingresoConVehiculo
                      ? CupertinoIcons.car_detailed
                      : Icons.directions_walk_sharp,
                  // color: context.watch<IngresosProvider>().model.vehiculo_id == 0 ? Colors.blueGrey : Colors.indigoAccent,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      context.watch<IngresosProvider>().ingresoConVehiculo
                          ? "Ingreso con Vehiculo".toUpperCase()
                          : "Ingreso sin vehiculo".toUpperCase(),
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.teko(),
                    ),
                  ),
                ),
              ],
            ),
          const Divider(color: Colors.blueGrey),
        ],
      ),
    );
  }
}
