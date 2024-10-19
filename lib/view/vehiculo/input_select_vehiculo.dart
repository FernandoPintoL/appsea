import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../../app/models/vehiculo_model.dart';
import '../../app/providers/ingresos_provider.dart';
import '../../app/providers/vehiculo_provider.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/metodos/UpperCaseTextFormatter.dart';
import '../components/widget/dialog.dart';

class InputSelectVehiculo extends StatefulWidget {
  const InputSelectVehiculo({super.key});

  @override
  State<InputSelectVehiculo> createState() => _InputSelectVehiculoState();
}

class _InputSelectVehiculoState extends State<InputSelectVehiculo> {
  late FocusNode focusVehiculo;
  List<Vehiculo> filter = [];

  void filtering(String query) async {
    await context.read<VehiculoProvider>().queryFilter(query);
  }

  @override
  void initState() {
    super.initState();
    focusVehiculo = FocusNode();
  }

  @override
  void dispose() {
    focusVehiculo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchField<Vehiculo>(
      key: const Key('searchfieldVehiculo'),
      controller: context.watch<VehiculoProvider>().selectVehiculoController,
      focusNode: focusVehiculo,
      textInputAction: TextInputAction.search,
      suggestionState: Suggestion.expand,
      inputType: TextInputType.text,
      dynamicHeight: true,
      maxSuggestionsInViewPort: 6,
      maxSuggestionBoxHeight: 150,
      // searchStyle: TextStyle(fontSize: 12),
      inputFormatters: [
        UpperCaseTextFormatter(),
      ],
      onSearchTextChanged: (query) {
        print(query);
        filtering(query);
        return context
            .read<VehiculoProvider>()
            .lista
            .map((e) => SearchFieldListItem(
                item: e,
                e.placa.toUpperCase(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('${e.placa.toUpperCase()} / ${e.tipo_vehiculo.toUpperCase()}'),
                )))
            .toList();
      },
      suggestions: context
          .read<VehiculoProvider>()
          .lista
          .map((e) => SearchFieldListItem(
              item: e,
              e.placa.toUpperCase(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('${e.placa.toUpperCase()} / ${e.tipo_vehiculo.toUpperCase()}'),
              )))
          .toList(),
      emptyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: FilledButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all<double>(8.0),
              backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            onPressed: () {
              print("SUCEDE AQUI EN EL VEHICULO");
              if (!context.read<IngresosProvider>().isRegisterVisitante) {
                DialogMessage()
                    .snackBar(context, "SELECCIONA O REGISTRA ALGUN VISITANTE PREVIAMENTE", "", Colors.redAccent);
              } else {
                context.read<IngresosProvider>().ingresoConVehiculo = true;
                context.read<IngresosProvider>().registerOnlyVehiculo = true;
                context.read<VisitanteProvider>().textAppBar = "Cargando Formulario".toUpperCase();
                context.read<VisitanteProvider>().isRegister = false;
                context.read<VisitanteProvider>().isRegister_formLayout = true;
                context.read<VisitanteProvider>().image = null;
                context.read<VisitanteProvider>().returnImage = null;
                // context.read<VehiculoProvider>().placaController.text = context.read<VehiculoProvider>().selectVehiculoController.text;
                context.read<VehiculoProvider>().image = null;
                context.read<VehiculoProvider>().returnImage = null;
              }
              if(!mounted || !context.mounted) return;
              focusVehiculo.unfocus();
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    'CREAR NUEVO',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                  ),
                ),
                Icon(
                  Icons.add_circle_outlined,
                  color: Colors.white,
                )
              ],
            )),
      ),
      onSuggestionTap: (SearchFieldListItem<Vehiculo> x) {
        if (x.item == null) return;
        if (!context.read<IngresosProvider>().isRegisterVisitante) {
          DialogMessage().snackBar(context, "SELECCIONA O REGISTRA ALGUN VISITANTE PREVIAMENTE", "", Colors.redAccent);
        } else {
          context.read<VehiculoProvider>().model = x.item!;
          context.read<IngresosProvider>().cargarModelVehiculo(x.item!);
          context.read<VehiculoProvider>().cargarGaleriaVehiculo(x.item!.id);
        }
        if(!mounted || !context.mounted) return;
        focusVehiculo.unfocus();
      },
      suggestionItemDecoration: SuggestionDecoration(elevation: 8.0),
      onTapOutside: (event) {
        if(!mounted || !context.mounted) return;
        focusVehiculo.unfocus();
        // FocusManager.instance.primaryFocus?.unfocus();
      },
      searchInputDecoration: SearchInputDecoration(
        labelStyle: const TextStyle(color: Colors.blueGrey, fontSize: 15),
        // counterText: context.watch<VehiculoProvider>().counterSearch,
        icon: context.read<VehiculoProvider>().isLoadingSelect ? const CircularProgressIndicator() : const CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(
              CupertinoIcons.car_detailed,
              color: Colors.white,
            )),
        label:
            const Text("SELECCIONE VEHICULO", style: TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
        suffixIcon: IconButton(
            onPressed: () async {
              if (context.read<IngresosProvider>().isRegisterVehiculo) {
                context.read<IngresosProvider>().deleteModelVehiculo();
              }
              context.read<VehiculoProvider>().clearSelectInputVehiculo();
              if(!mounted || !context.mounted) return;
              focusVehiculo.unfocus();
            },
            icon: const Icon(CupertinoIcons.trash_circle, size: 32,),
            highlightColor: Colors.orange,
            style: ButtonStyle(
                elevation: WidgetStateProperty.all<double?>(8),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                // backgroundColor: WidgetStateProperty.all<Color?>(Colors.blueGrey)
            )),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade200, width: 1), borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.withOpacity(0.8), width: 2),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
