import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sea/view/ingresos/search_visitante_vehiculo.dart';
import '../../app/models/vehiculo_model.dart';
import '../../app/models/visitante_model.dart';
import '../../app/providers/ingresos_provider.dart';
import '../../app/providers/residentes_providers.dart';
import '../../app/providers/vehiculo_provider.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/metodos/call_whtas.dart';
import '../components/widget/text_descriptivo.dart';
import '../ingresos/create_ingreso.dart';
import '../page_gestion/card_list.dart';

class ListResidentes extends StatefulWidget {
  ListResidentes({super.key});

  @override
  State<ListResidentes> createState() => _ListResidentesState();
}

class _ListResidentesState extends State<ListResidentes> {
  ScrollController scrollController = ScrollController();

  Future refresh() async {
    if (!context.read<ResidentesProvider>().isScrolleable) return;
    await context.read<ResidentesProvider>().queryListRange();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        // padding: EdgeInsets.symmetric(vertical: 6),
        shrinkWrap: true,
        itemCount: context.watch<ResidentesProvider>().lista.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < context.watch<ResidentesProvider>().lista.length) {
            return context.read<ResidentesProvider>().lista.isEmpty
                ? Text("Listado de residentes vacios...".toUpperCase())
                : Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CardList(
                      isRequiredTrailing: true,
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDescriptivo(
                                    title: "Cod: ",
                                    subtitle: context.read<ResidentesProvider>().lista[index].id.toString()),
                                TextDescriptivo(
                                    title: "Nombre: ",
                                    subtitle: context.read<ResidentesProvider>().lista[index].perfil.nombre.toString()),
                                if (context.read<ResidentesProvider>().lista[index].perfil.nroDocumento.isNotEmpty)
                                  TextDescriptivo(
                                      title: "Nro Doc.: ",
                                      subtitle: context
                                          .read<ResidentesProvider>()
                                          .lista[index]
                                          .perfil
                                          .nroDocumento
                                          .toString()),
                                TextDescriptivo(
                                    title: "Vivienda: ",
                                    subtitle: context.read<ResidentesProvider>().lista[index].vivienda.nroVivienda),
                                if (context.read<ResidentesProvider>().lista[index].perfil.celular.isNotEmpty)
                                  TextDescriptivo(
                                      title: "Cel.: ",
                                      subtitle: context.read<ResidentesProvider>().lista[index].perfil.celular),
                                Text(
                                  context.read<ResidentesProvider>().lista[index].isDuenho
                                      ? "Dueño".toUpperCase()
                                      : "Dependiente".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: context.read<ResidentesProvider>().lista[index].isDuenho
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.clip),
                                ),
                              ],
                            ),
                          ),
                          if (context.read<ResidentesProvider>().lista[index].perfil.celular.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: CircleAvatar(
                                    child: IconButton(
                                      tooltip: "WHATSSAP LLAMADA",
                                      icon: const Icon(FontAwesomeIcons.whatsapp),
                                      color: Colors.white,
                                      onPressed: () {
                                        if (context.read<ResidentesProvider>().lista[index].perfil.celular.isNotEmpty) {
                                          const String prefix = "+591";
                                          Calls().sendWhats(
                                              phone: prefix +
                                                  context.read<ResidentesProvider>().lista[index].perfil.celular,
                                              text: "");
                                        }
                                      },
                                      // highlightColor: Colors.green,
                                      // visualDensity: VisualDensity.adaptivePlatformDensity,
                                      style: ButtonStyle(
                                          elevation: WidgetStateProperty.all<double?>(8),
                                          shadowColor: WidgetStateProperty.all<Color?>(Colors.blueGrey.shade100),
                                          visualDensity: VisualDensity.adaptivePlatformDensity,
                                          backgroundColor: WidgetStateProperty.all<Color?>(Colors.green)),
                                    ),
                                    // backgroundColor: Colors.green.shade500,
                                  ),
                                ),
                                CircleAvatar(
                                  child: IconButton(
                                    tooltip: "LLAMADA NORMAL",
                                    icon: const Icon(FontAwesomeIcons.phone, color: Colors.white60),
                                    onPressed: () {
                                      if (context.read<ResidentesProvider>().lista[index].perfil.celular.isNotEmpty) {
                                        Calls().makePhoneCall(
                                            context.read<ResidentesProvider>().lista[index].perfil.celular);
                                      }
                                    },
                                    style: ButtonStyle(
                                        elevation: WidgetStateProperty.all<double?>(8),
                                        shadowColor: WidgetStateProperty.all<Color?>(Colors.blueGrey.shade100),
                                        visualDensity: VisualDensity.adaptivePlatformDensity,
                                        backgroundColor: WidgetStateProperty.all<Color?>(Colors.blueGrey.shade300)),
                                    // highlightColor: Colors.blueGrey,
                                  ),
                                  // backgroundColor: Colors.blueGrey.shade200,
                                ),
                              ],
                            )
                        ],
                      ),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.indigoAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      function: () {
                        print("cargando residente a ingreso");
                        context.read<ResidentesProvider>().changeLoading(true, "PREPARANDO FORMULARIO");
                        context
                            .read<IngresosProvider>()
                            .cargarModelResidente(context.read<ResidentesProvider>().lista[index]);
                        ///MOSTRAMOS EL FORMULARIO PARA SELECCIONAR VISITANTE Y VEHICULO
                        context.read<VisitanteProvider>().isRegister_formLayout = false;
                        context.read<VisitanteProvider>().clearOfResidente();
                        context.read<VehiculoProvider>().clearOfResidente();
                        context.read<ResidentesProvider>().changeLoading(false, "");
                        context.read<IngresosProvider>().textAppBar = "VISITANTE / VEHICULO";
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchVisitanteVehiculo()),
                        );
                      },
                    ),
                  );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: context.watch<ResidentesProvider>().hasMore
                    ? const CircularProgressIndicator()
                    : const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.info),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "NO HAY MAS DATOS",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }
        });
  }
}
