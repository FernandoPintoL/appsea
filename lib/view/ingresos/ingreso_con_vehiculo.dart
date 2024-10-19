import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/providers/ingresos_provider.dart';
import 'crear_ingreso.dart';

class IngresoVehiculo extends StatefulWidget {
  const IngresoVehiculo({super.key});

  @override
  State<IngresoVehiculo> createState() => _IngresoVehiculoState();
}

class _IngresoVehiculoState extends State<IngresoVehiculo> {
  FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();
    // focus = FocusNode();
  }

  @override
  void dispose() {
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      focusNode: focus,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inactiveThumbColor: Colors.redAccent,
      contentPadding: const EdgeInsets.only(bottom: 8, top: 8),
      activeColor: Colors.green,
      dense: true,
      value: context.watch<IngresosProvider>().ingresoConVehiculo,
      splashRadius: 28,
      selectedTileColor: Colors.yellow,
      onChanged: (bool value) {
        context.read<IngresosProvider>().ingresoConVehiculo = value;
        if(!value && context.read<IngresosProvider>().isRegisterVisitante){
          context.read<IngresosProvider>().textAppBar = "DATOS VISITA";
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CrearIngreso()),
          );
        }
      },
      title: Text("Ingreso con vehiculo : ".toUpperCase(),
          style: TextStyle(
            overflow: TextOverflow.clip,
            color: context.watch<IngresosProvider>().ingresoConVehiculo ? Colors.green : Colors.redAccent,
          )),
      subtitle: Text(
        context.watch<IngresosProvider>().ingresoConVehiculo ? "SI" : "NO",
        style: TextStyle(
            color: context.watch<IngresosProvider>().ingresoConVehiculo ? Colors.green : Colors.redAccent,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.clip),
      ),
      secondary: CircleAvatar(
        backgroundColor: context.watch<IngresosProvider>().ingresoConVehiculo ? Colors.green : Colors.redAccent,
        child: const Icon(CupertinoIcons.car_detailed, color: Colors.white),
      ),
    );
  }
}
