import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/providers/ingresos_provider.dart';
import '../vehiculo/input_select_vehiculo.dart';
import '../visita/input_select_visitante.dart';
import 'ingreso_con_vehiculo.dart';

class SelectCreateIngreso extends StatefulWidget {
  const SelectCreateIngreso({super.key});

  @override
  State<SelectCreateIngreso> createState() => _SelectCreateIngresoState();
}

class _SelectCreateIngresoState extends State<SelectCreateIngreso> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        //SELECT DE VISITANTES
        if (context.read<IngresosProvider>().isRegisterVisitante &&
            !context.read<IngresosProvider>().model.visitante.is_permitido)
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              'VISITANTE EN LISTA NEGRA',
              textAlign: TextAlign.end,
              style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.red),
            ),
          ),
        //BUSCADOR DE VISITANTES
        const InputSelectVisitante(),
        // INGRESO CON VEHICULO
        const IngresoVehiculo(),
        const SizedBox(height: 12),
        //SELECT DE VEHICULO
        if (context.watch<IngresosProvider>().ingresoConVehiculo) const InputSelectVehiculo(),
      ],
    );
  }
}
