import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/providers/ingresos_provider.dart';
import '../../app/providers/residentes_providers.dart';
import '../components/metodos/UpperCaseTextFormatter.dart';
import '../components/widget/appBar_title.dart';
import '../dashboard/drawerMenu.dart';
import '../page_gestion/page_gestion.dart';
import '../residentes/control_residentes_main_page.dart';
import 'list_ingresos.dart';

class IngresoView extends StatefulWidget {
  const IngresoView({super.key});

  @override
  State<IngresoView> createState() => _IngresoViewState();
}

class _IngresoViewState extends State<IngresoView> {
  late FocusNode focusQuery;
  DateTimeRange? selectedRange;
  String counterText = "";

  String _formatDateToString(DateTime? date) {
    if (date == null) return '-';
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  void initState() {
    super.initState();
    focusQuery = FocusNode();
    /*DateTime now = DateTime.timestamp();
    selectedRange = DateTimeRange(start: now, end: now);*/
  }

  @override
  void dispose() {
    focusQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: AppBarTitle(title: "INGRESOS"),
        actions: [
          IconButton(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              context.read<IngresosProvider>().changeLoading(true, "CARGANDO PAGINA");
              counterText = "";
              context.read<IngresosProvider>().clearList();
              context.read<IngresosProvider>().queryListRange();
              if (!context.mounted) return;
              context.read<IngresosProvider>().changeLoading(false, "");
              focusQuery.unfocus();
            },
          )
        ],
      ),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 25, left: 18, right: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                checkColor: Colors.white,
                activeColor: Colors.green,
                title: Text(
                    context.watch<IngresosProvider>().salidas_registradas
                        ? "SALIDAS REGISTRADAS"
                        : "SALIDAS SIN REGISTRAR",
                    overflow: TextOverflow.visible,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(context.watch<IngresosProvider>().queryDate, overflow: TextOverflow.visible),
                value: context.watch<IngresosProvider>().salidas_registradas,
                onChanged: (val) {
                  print(val);
                  context.read<IngresosProvider>().salidas_registradas = val!;
                  context.read<IngresosProvider>().queryList();
                }),
            TextFormField(
              controller: context.watch<IngresosProvider>().queryController,
              keyboardType: TextInputType.text,
              focusNode: focusQuery,
              textInputAction: TextInputAction.search,
              enableSuggestions: true,
              onTapOutside: (event) {
                focusQuery.unfocus();
              },
              inputFormatters: [
                UpperCaseTextFormatter(),
              ],
              onChanged: (value) {
                context.read<IngresosProvider>().queryList();
              },
              onFieldSubmitted: (value) async {
                context.read<IngresosProvider>().queryList();
                focusQuery.unfocus();
              },
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                  counterText:
                      "Consultados: ".toUpperCase() + context.watch<IngresosProvider>().lista.length.toString(),
                  counterStyle: const TextStyle(fontSize: 9),
                  icon: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      style: ButtonStyle(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        elevation: WidgetStateProperty.all<double>(12.0),
                        backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
                        shadowColor: WidgetStateProperty.all<Color?>(Colors.blueGrey.shade100),
                      ),
                      icon: const Icon(CupertinoIcons.calendar, color: Colors.white),
                      onPressed: () async {
                        DateTimeRange? result = await showDateRangePicker(
                            context: context,
                            locale: const Locale("es", "ES"),
                            firstDate: DateTime(DateTime.now().year - 5),
                            lastDate: DateTime(DateTime.now().year + 5),
                            currentDate: DateTime(DateTime.now().year),
                            initialDateRange: context.read<IngresosProvider>().selectedRange,
                            saveText: "Guardar",
                            useRootNavigator: true,
                            initialEntryMode: DatePickerEntryMode.input,
                            fieldStartLabelText: "Inicio",
                            fieldEndLabelText: "Final",
                            fieldStartHintText: "mm/dd/yyyy",
                            fieldEndHintText: "mm/dd/yyyy",
                            keyboardType: TextInputType.datetime,
                            cancelText: "CANCELAR",
                            confirmText: "ACEPTAR");
                        if (result != null) {
                          print(result);
                          if (!context.mounted) return;
                          String start = "${_formatDateToString(result.start)} 00:00:00";
                          String end = "${_formatDateToString(result.end)} 23:59:59";
                          context.read<IngresosProvider>().queryDate = '$start / $end';
                          context.read<IngresosProvider>().created_at_start = start;
                          context.read<IngresosProvider>().created_at_end = end;
                          context.read<IngresosProvider>().queryList();
                          focusQuery.unfocus();
                        }
                      },
                    ),
                  ),
                  suffixIcon: IconButton(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    icon: const Icon(Icons.search),
                    onPressed: () async {
                      // String query = context.read<IngresosProvider>().queryController.text;
                      context.read<IngresosProvider>().queryList();
                      focusQuery.unfocus();
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  labelText: "Buscador".toUpperCase(),
                  labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            ),
            /*CupertinoCheckbox(
                value: context.watch<IngresosProvider>().salidas_sin_registrar,
                onChanged: (val) {
                  context.read<IngresosProvider>().salidas_sin_registrar = val!;
                }),*/

            Expanded(
              child: PageGestion(
                label: "Buscador de Ingresos",
                isRequiredQuery: false,
                isLoading: context.watch<IngresosProvider>().isLoading,
                textLoading: context.watch<IngresosProvider>().textLoading,
                queryController: context.watch<IngresosProvider>().queryController,
                focusNode: focusQuery,
                httpResponsse: context.watch<IngresosProvider>().httpResponsse,
                listado: context.watch<IngresosProvider>().lista,
                isListEmpty: context.watch<IngresosProvider>().lista.isEmpty,
                functionBuscar: () {
                  ///COLOCAR EL METODO DE BUSQUEDA
                  // context.read<IngresosProvider>().queryController.clear();
                  // context.read<IngresosProvider>().queryList(context.read<IngresosProvider>().queryController.text);
                },
                refrescarPagina: () async {
                  ///RECARGAR LA PAGINA
                  /// context.read<IngresosProvider>().queryController.clear();
                  /// context.read<IngresosProvider>().queryList("");

                  context.read<IngresosProvider>().changeLoading(true, "CARGANDO PAGINA");
                  counterText = "";
                  context.read<IngresosProvider>().clearList();
                  await context.read<IngresosProvider>().queryListRange();
                  if (!context.mounted) return;
                  context.read<IngresosProvider>().changeLoading(false, "");
                },
                registrarNuevo: () {
                  // USAR NAVIGATOR
                  context.read<IngresosProvider>().queryController.clear();
                  context.read<IngresosProvider>().cargarFormularioRegister();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ResidentesView()),
                  );
                },
                listadoWidget: ListIngresos(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade900,
        elevation: 18,
        shape: const CircleBorder(),
        splashColor: Colors.orange,
        onPressed: () async {
          // context.read<IngresosProvider>().cargarFormularioRegister();
          context.read<IngresosProvider>().queryController.clear();
          context.read<IngresosProvider>().isRegister = true;
          if (context.read<ResidentesProvider>().lista.isEmpty) {
            context.read<ResidentesProvider>().skip = 0;
            context.read<ResidentesProvider>().take = 10;
            context.read<IngresosProvider>().changeLoading(true, "CARGANDO RESIDENTES");
            context.read<ResidentesProvider>().changeLoading(true, "CARAGANDO RESIDENTES");
            context.read<ResidentesProvider>().clearList();
            await context.read<ResidentesProvider>().queryList();
            if (!context.mounted) return;
            context.read<ResidentesProvider>().changeLoading(false, "");
            context.read<IngresosProvider>().changeLoading(false, "");
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResidentesView()),
          );
        },
        tooltip: "Registra un nuevo ingreso".toUpperCase(),
        child: const Icon(CupertinoIcons.add_circled, color: Colors.white),
      ),
    );
  }
}
