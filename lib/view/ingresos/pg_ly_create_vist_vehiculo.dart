import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/providers/ingresos_provider.dart';
import '../../app/providers/vehiculo_provider.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/widget/dialog.dart';
import '../page_gestion/page_gestion.dart';
import '../vehiculo/form_vehiculo.dart';
import '../visita/form_visitante.dart';
import 'ingreso_con_vehiculo.dart';
import 'select_create_ingreso.dart';

class PageCreateVisitante extends StatefulWidget {
  const PageCreateVisitante({super.key});

  @override
  State<PageCreateVisitante> createState() => _PageCreateVisitanteState();
}

class _PageCreateVisitanteState extends State<PageCreateVisitante> {
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<VisitanteProvider>().isRegister_formLayout
        ? Column(
            //FORMULARIO DE REGISTRO VEHICULO Y VISITANTE
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!context.watch<IngresosProvider>().registerOnlyVehiculo) const FormNewVisitante(),
              // INGRESO CON VEHICULO
              if (!context.watch<IngresosProvider>().registerOnlyVehiculo)
                Column(
                  children: [
                    const IngresoVehiculo(),
                    if(context.watch<IngresosProvider>().ingresoConVehiculo)
                        const FormNewVehiculo()
                  ],
                ),
              const SizedBox(
                height: 40,
              ),
              ButtonFormPage(
                  widgetStateProperty: WidgetStateProperty.all<Color>(Colors.green),
                  function: () async {
                    if (context.read<VisitanteProvider>().isRegister) {
                      if (!context.read<VisitanteProvider>().formKey.currentState!.validate()) {
                        DialogMessage().snackBar(context, "FORMULARIO NO VALIDADO", "", Colors.redAccent);
                        return;
                      }
                      if (context.read<VisitanteProvider>().image == null) {
                        DialogMessage().snackBar(context, "PORFAVOR CARGAR IMAGEN DEL VISITANTE", "", Colors.redAccent);
                        return;
                      }
                    }
                    if (context.read<IngresosProvider>().ingresoConVehiculo) {
                      if (!context.read<VehiculoProvider>().formKey.currentState!.validate()) {
                        DialogMessage().snackBar(context, "FORMULARIO NO VALIDADO", "", Colors.redAccent);
                        return;
                      }

                      if (context.read<VehiculoProvider>().image == null) {
                        DialogMessage().snackBar(context, "PORFAVOR CARGAR IMAGEN DEL VEHICULO", "", Colors.redAccent);
                        return;
                      }
                    }
                    await _dialogBuilder(context);
                  },
                  textButton: "Registrar"),
              const SizedBox(
                height: 200,
              ),
            ],
          )
        : const SelectCreateIngreso();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Estas Seguro de Registrar estos datos?'.toUpperCase(),
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold)),
            content: const Text("",
                maxLines: 3,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold)),
            actions: <Widget>[
              context.watch<IngresosProvider>().isLoading
                  ? const Center(child: Text("Cargando..."))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //BUTTON CANCELAR
                        FilledButton(
                          style: ButtonStyle(
                              visualDensity: VisualDensity.adaptivePlatformDensity,
                              elevation: WidgetStateProperty.all<double?>(3),
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.red)),
                          child: Text('Cancelar'.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.white, overflow: TextOverflow.ellipsis)),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                        FilledButton(
                          style: ButtonStyle(
                              visualDensity: VisualDensity.adaptivePlatformDensity,
                              elevation: WidgetStateProperty.all<double?>(3),
                              backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                          child: Text('Aceptar'.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.white, overflow: TextOverflow.ellipsis)),
                          onPressed: () async {
                            bool isReegisterVisitanteExitoso = true;
                            context.read<IngresosProvider>().isLoading = true;

                            /// REGISTRO DEL VISITANTE
                            if (context.read<VisitanteProvider>().isRegister) {
                              await context.read<VisitanteProvider>().registrarModelo(context);
                              if (!context.mounted) return;
                              if (context.read<VisitanteProvider>().httpResponsse.isSuccess) {
                                ///REGISTRANDO EL MODEL EN INGRESOS PROVIDERS
                                context
                                    .read<IngresosProvider>()
                                    .cargarModelVisitante(context.read<VisitanteProvider>().model);
                                context.read<IngresosProvider>().isRegisterVisitante = true;
                                context.read<IngresosProvider>().textAppBar = "DATOS INGRESO";
                                context.read<IngresosProvider>().registerOnlyVehiculo = true;
                              } else {
                                context.read<IngresosProvider>().registerOnlyVehiculo = false;
                                isReegisterVisitanteExitoso = false;
                                context.read<IngresosProvider>().isLoading = false;
                                Navigator.pop(context);
                                return;
                              }
                            }

                            ///CARGAR IMAGEN DEL VISITANTE
                            if (context.read<VisitanteProvider>().model.id != 0 &&
                                context.read<VisitanteProvider>().listImagenes.isEmpty) {
                              await context.read<VisitanteProvider>().uploadImage(context);
                              if (!context.mounted) return;
                              if (!context.read<VisitanteProvider>().httpResponsse.isSuccess) {
                                context.read<IngresosProvider>().isLoading = false;
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              }
                            }
                            if (!context.mounted) return;

                            /// REGISTRANDO VEHICULO
                            if (isReegisterVisitanteExitoso && context.read<IngresosProvider>().ingresoConVehiculo) {
                              context.read<VisitanteProvider>().changeLoading(true, "REGISTRANDO VEHICULO");
                              await context
                                  .read<VehiculoProvider>()
                                  .registrarModelo(context, context.read<VisitanteProvider>().model.id);
                              if (!context.mounted) return;
                              // context.read<VisitanteProvider>().changeLoading(false, "");

                              if (context.read<VehiculoProvider>().httpResponsse.isSuccess) {
                                context
                                    .read<IngresosProvider>()
                                    .cargarModelVehiculo(context.read<VehiculoProvider>().model);
                                context.read<IngresosProvider>().isRegisterVehiculo = true;
                                context.read<IngresosProvider>().isBlackList = false;
                                context.read<IngresosProvider>().textAppBar = "DATOS DEL INGRESO";

                                context.read<VisitanteProvider>().isRegister_formLayout = false;
                                // context.read<VisitanteProvider>().textLoadingShowModal = "";
                                context.read<VisitanteProvider>().changeLoading(false, "");
                              } else {
                                context.read<VisitanteProvider>().isRegister_formLayout = true;
                                context.read<VisitanteProvider>().changeLoading(false, "");
                                context.read<IngresosProvider>().isLoading = false;
                                Navigator.pop(context);
                                return;
                              }
                            }

                            ///CARGAR IMAGEN DEL VEHICULO
                            if (context.read<VehiculoProvider>().model.id != 0 &&
                                context.read<VehiculoProvider>().listImagenes.isEmpty) {
                              context.read<VisitanteProvider>().changeLoading(true, "REGISTRANDO IMAGEN VEHICULO");
                              await context.read<VehiculoProvider>().uploadImage(context);
                              if (!context.mounted) return;

                              if (context.read<VehiculoProvider>().httpResponsse.isSuccess) {
                                context.read<VisitanteProvider>().isRegister_formLayout = false;
                                context.read<VisitanteProvider>().changeLoading(false, "");
                              } else {
                                context.read<IngresosProvider>().isLoading = false;
                                context.read<VisitanteProvider>().isRegister_formLayout = true;
                                context.read<VisitanteProvider>().changeLoading(false, "");
                                if (!context.mounted) return;
                                Navigator.pop(context);
                              }
                            }
                            context.read<IngresosProvider>().isLoading = false;
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
            ],
          );
        });
  }
}
