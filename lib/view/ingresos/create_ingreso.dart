import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/providers/ingresos_provider.dart';
import '../../app/providers/vehiculo_provider.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/widget/appBar_title.dart';
import '../components/widget/loading.dart';
import 'pg_ly_create_vist_vehiculo.dart';
import 'form_ingreso.dart';
import 'header_ingresos.dart';

class CreateIngreso extends StatefulWidget {
  const CreateIngreso({super.key});

  @override
  State<CreateIngreso> createState() => _CreateIngresoState();
}

class _CreateIngresoState extends State<CreateIngreso> {
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
        backgroundColor: context.watch<IngresosProvider>().isIngresoAutorizado ? Colors.green : Colors.red,
        title: AppBarTitle(title: context.watch<IngresosProvider>().textAppBar.toUpperCase()),
        leading: IconButton(
            onPressed: () {
              context.read<IngresosProvider>().deleteModelVisitante();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              CupertinoIcons.arrow_left,
              color: Colors.white,
            )),

        actions: [
          if (!context.watch<IngresosProvider>().isRegisterVisitante &&
              !context.read<IngresosProvider>().isRegisterVehiculo)
            Row(
              children: [
                IconButton(
                      style: ButtonStyle(
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          elevation: WidgetStateProperty.all<double>(8.0),
                          shadowColor: WidgetStateProperty.all<Color>(Colors.blueGrey.shade100),
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.blueAccent)),
                      color: Colors.blueAccent,
                      splashColor: Colors.orange,
                      highlightColor: Colors.orange,
                      onPressed: () async {
                        if(context.read<VisitanteProvider>().isRegister_formLayout){
                          context.read<VisitanteProvider>().clearController();
                          context.read<VehiculoProvider>().clearController();
                          context.read<VisitanteProvider>().isRegister_formLayout = false;
                        }else{
                          await context.read<VisitanteProvider>().cargarFormulario();
                          if(!context.mounted) return;
                          context.read<IngresosProvider>().registerOnlyVehiculo = false;
                          context.read<IngresosProvider>().isRegister_formLayout = true;
                          context.read<VisitanteProvider>().isRegister_formLayout = true;
                          context.read<VehiculoProvider>().image = null;
                          context.read<VehiculoProvider>().returnImage = null;
                        }
                      },
                      icon: Icon(
                        context.watch<VisitanteProvider>().isRegister_formLayout ? CupertinoIcons.search_circle : CupertinoIcons.add_circled,
                        color: Colors.white,
                      )),
                IconButton(
                    style: ButtonStyle(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        elevation: WidgetStateProperty.all<double>(8.0),
                        shadowColor: WidgetStateProperty.all<Color>(Colors.blueGrey.shade100),
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue.shade700)),
                    color: Colors.blueGrey,
                    splashColor: Colors.orange,
                    highlightColor: Colors.orange,
                    onPressed: () {
                        context.read<IngresosProvider>().deleteModelVehiculo();
                        context.read<IngresosProvider>().deleteModelVisitante();
                        context.read<VisitanteProvider>().clearOfResidente();
                        context.read<VehiculoProvider>().clearOfResidente();
                    },
                    icon: const Icon(
                      CupertinoIcons.refresh_thick,
                      color: Colors.white,
                    )),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 28, left: 18, right: 18),
        child: context.watch<VisitanteProvider>().isLoading
            ? Loading(text: context.watch<VisitanteProvider>().textLoading.toUpperCase())
            : ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  if (!context.watch<VisitanteProvider>().isRegister_formLayout)
                    // CABECERA DEL REGISTRO
                    const HeaderIngresos(),
                  const SizedBox(height: 8),
                  if (!context.watch<IngresosProvider>().isRegisterVisitante ||
                      (!context.watch<IngresosProvider>().isRegisterVehiculo &&
                          context.watch<IngresosProvider>().ingresoConVehiculo))
                    const PageCreateVisitante() //CREAR O SELECCIONAR VEHICULO VISITANTE
                  else
                    const FormIngreso(), // REGISTRANDO EL INGRESO
                  const SizedBox(height: 200),
                ],
              ),
      ),
    );
  }
}
