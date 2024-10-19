import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../../app/models/visitante_model.dart';
import '../../app/providers/ingresos_provider.dart';
import '../../app/providers/vehiculo_provider.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/metodos/UpperCaseTextFormatter.dart';

class InputSelectVisitante extends StatefulWidget {
  const InputSelectVisitante({super.key});

  @override
  State<InputSelectVisitante> createState() => _InputSelectVisitanteState();
}

class _InputSelectVisitanteState extends State<InputSelectVisitante> {
  late FocusNode focusVisitante;
  // List<Visitante> filter = [];

  void filtering(String query) async {
    await context.read<VisitanteProvider>().queryFilter(query);
  }

  @override
  void initState() {
    super.initState();
    focusVisitante = FocusNode();
  }

  @override
  void dispose() {
    focusVisitante.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchField<Visitante>(
      key: const Key('searchfieldVisitante'),
      controller: context.watch<VisitanteProvider>().selectVisitanteController,
      focusNode: focusVisitante,
      suggestionState: Suggestion.expand,
      inputType: TextInputType.text,
      textInputAction: TextInputAction.search,
      dynamicHeight: true,
      maxSuggestionsInViewPort: 6,
      maxSuggestionBoxHeight: 250,
      // searchStyle: TextStyle(fontSize: 12),
      inputFormatters: [
        UpperCaseTextFormatter(),
      ],
      /*onSubmit: (query){
        print("----------presionando on submit------------");
        filtering(query);
      },*/
      onSearchTextChanged: (query){
        print(query);
        filtering(query);
        return context
            .read<VisitanteProvider>()
            .lista
            .map((e) => SearchFieldListItem(
                item: e,
                '${e.perfil.nombre} / Doc: ${e.perfil.nroDocumento}',
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text('${e.perfil.nombre} / Doc: ${e.perfil.nroDocumento}'),
                )))
            .toList();
      },
      suggestions: context
          .read<VisitanteProvider>()
          .lista
          .map((e) => SearchFieldListItem(
              item: e,
              '${e.perfil.nombre} / Doc: ${e.perfil.nroDocumento}',
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${e.perfil.nombre} / Doc: ${e.perfil.nroDocumento}'),
                    if (!e.is_permitido)
                      Text(
                        "Se encuentra en lista negra".toUpperCase(),
                        style: const TextStyle(fontSize: 10, color: Colors.redAccent),
                      )
                  ],
                ),
              )))
          .toList(),
      emptyWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: FilledButton(
            style: ButtonStyle(
                elevation: WidgetStateProperty.all<double>(8.0),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                shadowColor: WidgetStateProperty.all<Color>(Colors.blueAccent.shade100),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blueAccent),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.orange)),
            onPressed: () {
              context.read<VisitanteProvider>().cargarFormulario();
              context.read<IngresosProvider>().registerOnlyVehiculo = false;
              context.read<IngresosProvider>().isRegister_formLayout = true;
              context.read<VisitanteProvider>().isRegister_formLayout = true;
              context.read<VisitanteProvider>().isRegister = true;
              context.read<VehiculoProvider>().image = null;
              context.read<VehiculoProvider>().returnImage = null;
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('CREAR NUEVO',
                    style:
                        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
                Icon(
                  Icons.add_circle_outlined,
                  color: Colors.white,
                )
              ],
            )),
      ),
      onSuggestionTap: (SearchFieldListItem<Visitante> x) {
        print("SUCEDE AQUI");
        if (x.item == null) return;
        context.read<VisitanteProvider>().model = x.item!;
        context.read<IngresosProvider>().cargarModelVisitante(x.item!);
        context.read<VisitanteProvider>().cargarGaleriaVisitantes(x.item!.id);
        if(!mounted || !context.mounted) return;
        focusVisitante.unfocus();
      },
      onTapOutside: (event) {
        print("EVENTOOOOOO");
        print("------------------");
        if(!mounted || !context.mounted) return;
        focusVisitante.unfocus();
        // FocusManager.instance.primaryFocus?.unfocus();
        // focusVisitante.dispose();
      },
      searchInputDecoration: SearchInputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade200, width: 1), borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.withOpacity(0.8), width: 2),
            borderRadius: BorderRadius.circular(20)),
        labelStyle: const TextStyle(color: Colors.blueGrey),
        // counterText: context.watch<VisitanteProvider>().counterSearch,
        suffixIcon: IconButton(
          onPressed: () async {
            if (context.read<IngresosProvider>().isRegisterVisitante) {
              context.read<IngresosProvider>().deleteModelVisitante();
            }
            context.read<VisitanteProvider>().clearSelectInputVisitante();
            if(!mounted || !context.mounted) return;
            focusVisitante.unfocus();
          },
          icon: const Icon(CupertinoIcons.trash_circle, size: 32,),
          highlightColor: Colors.orange,
          style: ButtonStyle(
              elevation: WidgetStateProperty.all<double>(8),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              // backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey),
              // shadowColor: WidgetStateProperty.all<Color>(Colors.blueGrey.shade100)
          ),
        ),
        icon: context.read<VisitanteProvider>().isLoadingSelect
            ? const CircularProgressIndicator()
            : const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                )),
        label: const Text("SELECCIONE VISITANTE",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
        // counterText: context.watch<VisitanteProvider>().visitantesCargados
      ),
    );
  }
}
