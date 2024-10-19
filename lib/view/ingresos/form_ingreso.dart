import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/models/tipo_visita_model.dart';
import '../../app/providers/ingresos_provider.dart';
import '../../app/providers/vehiculo_provider.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/widget/loading.dart';
import '../page_gestion/page_gestion.dart';
import 'upload_image_visit_car.dart';

class FormIngreso extends StatefulWidget {
  const FormIngreso({super.key});

  @override
  State<FormIngreso> createState() => _FormIngresoState();
}

class _FormIngresoState extends State<FormIngreso> {
  late FocusNode focusResidentes;
  late FocusNode focusDetalleIngreso;
  late FocusNode focusDetalleSalidaIngreso;
  late FocusNode focusIngresoPermitido;
  late FocusNode focusTipoVisita;

  @override
  void initState() {
    super.initState();
    focusResidentes = FocusNode();
    focusDetalleIngreso = FocusNode();
    focusDetalleSalidaIngreso = FocusNode();
    focusIngresoPermitido = FocusNode();
    focusTipoVisita = FocusNode();
  }

  @override
  void dispose() {
    focusResidentes.dispose();
    focusDetalleIngreso.dispose();
    focusDetalleSalidaIngreso.dispose();
    focusIngresoPermitido.dispose();
    focusTipoVisita.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<IngresosProvider>().isLoading
        ? Loading(text: "Cargando Formulario")
        : Form(
            key: context.read<IngresosProvider>().formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("MOTIVO DE VISITA: ",
                        style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold)),
                    if(!context.watch<IngresosProvider>().isRegister)
                      Text(context.watch<IngresosProvider>().model.tipoVisita.detalle.toUpperCase(),
                          style: TextStyle(
                              color: context.read<IngresosProvider>().model.isAutorizado ? Colors.green : Colors.red,
                              fontSize: 14,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold)
                      ),
                  ],
                ),
                if (context.watch<IngresosProvider>().listaTipoVisita.isNotEmpty && context.watch<IngresosProvider>().isRegister)
                  DropdownButton<TipoVisita>(
                    value: context.watch<IngresosProvider>().tipoVisita,
                    focusNode: focusTipoVisita,
                    icon: Icon(Icons.arrow_downward),
                    elevation: 16,
                    isExpanded: true,
                    onChanged: (TipoVisita? value) {
                      setState(() {
                        context.read<IngresosProvider>().tipoVisita = value!;
                      });
                    },
                    items: context
                        .watch<IngresosProvider>()
                        .listaTipoVisita
                        .map<DropdownMenuItem<TipoVisita>>((TipoVisita value) {
                      return DropdownMenuItem<TipoVisita>(
                        value: value,
                        child: Text(
                          "id: ".toUpperCase() + value.id.toString() + " / " + value.detalle.toUpperCase(),
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 13,
                          ),
                        ),
                      );
                    }).toList(),
                  )
                else if(context.watch<IngresosProvider>().isRegister)
                  Text("Cargando Tipo de Visitas...".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                          fontStyle: FontStyle.italic,
                          overflow: TextOverflow.ellipsis)),
                if(context.watch<IngresosProvider>().isRegister)
                  // INGRESO AUTORIZADO
                  SwitchListTile(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    inactiveThumbColor: Colors.redAccent,
                    activeColor: Colors.green,
                    contentPadding: const EdgeInsets.only(bottom: 8, top: 8),
                    value: context.watch<IngresosProvider>().isIngresoAutorizado,
                    focusNode: focusIngresoPermitido,
                    dense: true,
                    onChanged: (bool value) {
                      if (context.read<IngresosProvider>().model.visitante.is_permitido) {
                        context.read<IngresosProvider>().isIngresoAutorizado = value;
                        if (!context.read<IngresosProvider>().isIngresoAutorizado) {
                          context.read<IngresosProvider>().isBlackList = (true);
                          TipoVisita tipo = context.read<IngresosProvider>().listaTipoVisita.firstWhere((e) => e.id == 4);
                          context.read<IngresosProvider>().tipoVisita = tipo;
                          context.read<IngresosProvider>().detalleController.text =
                              "INGRESO NO PERMITIDO EL VISITANTE SE ENCUENTRA EN LISTA NEGRA".toUpperCase();
                        } else {
                          context.read<IngresosProvider>().isBlackList = (false);
                          TipoVisita tipo = context.read<IngresosProvider>().listaTipoVisita.firstWhere((e) => e.id == 1);
                          context.read<IngresosProvider>().tipoVisita = tipo;
                          context.read<IngresosProvider>().detalleController.text = "";
                        }
                      }
                    },
                    title: Text("Ingreso Autorizado : ".toUpperCase(),
                        style: TextStyle(
                            color: context.watch<IngresosProvider>().isIngresoAutorizado ? Colors.green : Colors.red,
                            overflow: TextOverflow.clip)),
                    subtitle: Text(
                      context.watch<IngresosProvider>().isIngresoAutorizado ? "SI" : "NO",
                      style: TextStyle(
                          color: context.watch<IngresosProvider>().isIngresoAutorizado ? Colors.green : Colors.redAccent,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.clip),
                    ),
                    secondary: CircleAvatar(
                      backgroundColor:
                          context.watch<IngresosProvider>().isIngresoAutorizado ? Colors.green : Colors.redAccent,
                      child: Icon(
                          context.watch<IngresosProvider>().isIngresoAutorizado
                              ? CupertinoIcons.check_mark_circled
                              : Icons.dangerous_outlined,
                          color: Colors.white),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(context.read<IngresosProvider>().model.isAutorizado ? Icons.check_circle_outline : Icons.dangerous_outlined,
                          color: context.read<IngresosProvider>().model.isAutorizado ? Colors.green : Colors.red,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(context.read<IngresosProvider>().model.isAutorizado ? "INGRESO AUTORIZADO" : "INGRESO NO AUTORIZADO",
                                style: TextStyle(
                                  color: context.read<IngresosProvider>().model.isAutorizado ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w200,
                                  fontStyle: FontStyle.italic,
                                  overflow: TextOverflow.ellipsis)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if(context.watch<IngresosProvider>().isRegister)
                  //DETALLE DE INGRESO
                  Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    minLines: 1,
                    maxLines: 26,
                    controller: context.watch<IngresosProvider>().detalleController,
                    focusNode: focusDetalleIngreso,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.send,
                    onTapOutside: (event) {
                      focusDetalleIngreso.unfocus();
                    },
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                        labelText: "Detalle para el ingreso".toUpperCase(),
                        labelStyle: TextStyle(fontSize: 13),
                        icon: Icon(CupertinoIcons.captions_bubble)),
                  ),
                )
                else
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Detalle: ${context.read<IngresosProvider>().model.detalle.toString().toUpperCase()}",
                        style: TextStyle(
                            color: context.read<IngresosProvider>().model.isAutorizado ? Colors.green : Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            fontStyle: FontStyle.italic,
                            overflow: TextOverflow.ellipsis)
                    ),
                  ),
                // DETALLE SALIDA DEL INGRESO
                if (!context.watch<IngresosProvider>().isRegister &&
                    context.watch<IngresosProvider>().model.isAutorizado &&
                    context.watch<IngresosProvider>().model.salida_created_at!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      minLines: 1,
                      maxLines: 26,
                      controller: context.watch<IngresosProvider>().detalleSalidaController,
                      focusNode: focusDetalleSalidaIngreso,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.send,
                      onTapOutside: (event) {
                        focusDetalleSalidaIngreso.unfocus();
                      },
                      decoration: InputDecoration(
                          labelText: "Detalle de salidas".toUpperCase(), icon: Icon(CupertinoIcons.captions_bubble)),
                    ),
                  )
                else if(!context.watch<IngresosProvider>().isRegister)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Detalle Salida: ${context.read<IngresosProvider>().model.detalleSalida.toString().toUpperCase()}",
                        style: TextStyle(
                            color: context.read<IngresosProvider>().model.isAutorizado ? Colors.green : Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w200,
                            fontStyle: FontStyle.italic,
                            overflow: TextOverflow.ellipsis)
                    ),
                  ),
                //BUTTON FORMULARIO
                if (context.read<IngresosProvider>().isRegister)
                  Padding(
                    padding: const EdgeInsets.only(right: 26.0, left: 26.0, bottom: 10.0, top: 12.0),
                    child: ButtonFormPage(
                        widgetStateProperty: context.watch<IngresosProvider>().isIngresoAutorizado
                            ? WidgetStateProperty.all<Color>(Colors.green)
                            : WidgetStateProperty.all<Color>(Colors.redAccent),
                        function: () async {
                          if (!context.read<IngresosProvider>().isRegister) {
                            await registrarTransaccion(context);
                            return;
                          } else {
                            if (context.read<VisitanteProvider>().listImagenes.isEmpty) {
                              context.read<IngresosProvider>().anuncios =
                                  ("ingrese imagenes para poder continuar").toUpperCase();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UploadImageVisitCar()),
                              );
                              return;
                            }
                            if (context.read<IngresosProvider>().ingresoConVehiculo &&
                                context.read<VehiculoProvider>().listImagenes.isEmpty) {
                              context.read<IngresosProvider>().anuncios =
                                  ("ingrese imagenes para poder continuar").toUpperCase();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => UploadImageVisitCar()),
                              );
                              return;
                            }
                            await registrarTransaccion(context);
                          }
                        },
                        textButton: context.read<IngresosProvider>().isRegister ? "Registrar" : "Actualizar"),
                  ),
              ],
            ));
  }

  Future<void> registrarTransaccion(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            buttonPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: Text('Estas Seguro de Registrar estos datos?'.toUpperCase(),
                maxLines: 3,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold)),
            content: !context.watch<IngresosProvider>().isIngresoAutorizado &&
                    context.watch<IngresosProvider>().model.visitante.is_permitido
                ? SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    inactiveThumbColor: Colors.green,
                    activeColor: Colors.red,
                    value: context.watch<IngresosProvider>().isBlackList,
                    dense: true,
                    onChanged: (bool value) {
                      context.read<IngresosProvider>().isBlackList = (value);
                    },
                    title: Text("Deseas registar el visitante en lista negra?".toUpperCase(),
                        style: TextStyle(
                            color: context.watch<IngresosProvider>().isBlackList ? Colors.red : Colors.green,
                            overflow: TextOverflow.visible)),
                    subtitle: Text(
                      context.watch<IngresosProvider>().isBlackList ? "SI" : "NO",
                      style: TextStyle(
                          color: context.watch<IngresosProvider>().isBlackList ? Colors.redAccent : Colors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.clip),
                    ),
                    secondary: CircleAvatar(
                      backgroundColor: context.watch<IngresosProvider>().isBlackList ? Colors.redAccent : Colors.green,
                      child: Icon(
                          context.watch<IngresosProvider>().isBlackList
                              ? Icons.dangerous_outlined
                              : CupertinoIcons.check_mark_circled,
                          color: Colors.white),
                    ),
                  )
                : const Text(""),
            actions: <Widget>[
              context.watch<IngresosProvider>().isLoading
                  ? const Center(child: Text("Cargando..."))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // scrollDirection: Axis.vertical,
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
                          child: Text('aceptar'.toUpperCase(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.white, overflow: TextOverflow.ellipsis)),
                          onPressed: () async {
                            if (context.read<IngresosProvider>().isRegister) {
                              context.read<IngresosProvider>().registrarNewModelo(context);
                            } else {
                              context.read<IngresosProvider>().updateModel(context);
                            }
                          },
                        ),
                      ],
                    ),
            ],
          );
        });
  }
}
