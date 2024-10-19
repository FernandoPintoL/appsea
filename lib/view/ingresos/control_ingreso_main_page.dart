import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/providers/ingresos_provider.dart';
import '../components/widget/appBar_title.dart';
import '../components/widget/loading.dart';
import 'form_ingreso.dart';
import 'header_ingresos.dart';

class ControlIngresoMainPage extends StatefulWidget {
  const ControlIngresoMainPage({super.key});

  @override
  State<ControlIngresoMainPage> createState() => _ControlIngresoMainPageState();
}

class _ControlIngresoMainPageState extends State<ControlIngresoMainPage> {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: context.watch<IngresosProvider>().isIngresoAutorizado ? Colors.green : Colors.redAccent,
        title: AppBarTitle(
            title: context.watch<IngresosProvider>().isRegister
                ? "datos del ingreso".toUpperCase()
                : "ACTUALIZACION DE DATOS"),
      ),
      body: context.watch<IngresosProvider>().isLoading
          ? Loading(text: "Cargando Formulario")
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
              child: ListView(
                children: [
                  if (!context.watch<IngresosProvider>().isRegister)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("ID: ${context.watch<IngresosProvider>().model.id}",
                                style: TextStyle(
                                    color: context.watch<IngresosProvider>().isIngresoAutorizado
                                        ? Colors.green
                                        : Colors.red,
                                    overflow: TextOverflow.ellipsis,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Registrado: \n${context.watch<IngresosProvider>().model.created_at}",
                                      style: const TextStyle(
                                          color: Colors.green,
                                          overflow: TextOverflow.ellipsis,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600)),
                                  if (context.watch<IngresosProvider>().model.isAutorizado &&
                                      context.watch<IngresosProvider>().model.salida_created_at!.isNotEmpty)
                                    Text(
                                        "Registro Salida: \n${context.watch<IngresosProvider>().model.salida_created_at}",
                                        style: const TextStyle(
                                            color: Colors.blueGrey,
                                            overflow: TextOverflow.ellipsis,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.blueGrey,
                        ),
                        const HeaderIngresos(),
                      ],
                    ),
                  const SizedBox(
                    height: 12,
                  ),
                  //CREACION DE DATOS FINALES PARA EL INGRESO
                  const FormIngreso(),

                ],
              ),
            ),
    );
  }
}
