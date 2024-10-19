import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../app/models/http_response.dart';
import '../components/widget/loading.dart';
import '../components/widget/search_text_field.dart';
import 'page_response.dart';

class PageGestion extends StatelessWidget {
  bool isLoading;
  HttpResponsse httpResponsse;
  TextEditingController queryController;
  FocusNode focusNode;
  Function functionBuscar;
  Function registrarNuevo;
  Function refrescarPagina;
  bool isListEmpty;
  bool isIconRequired;
  List listado;
  Widget listadoWidget;
  String textLoading;
  String label;
  bool withBottomRefresh;
  bool isRequiredQuery;

  PageGestion(
      {super.key,
      required this.label,
      this.isLoading = false,
      required this.httpResponsse,
      required this.queryController,
      required this.focusNode,
      required this.functionBuscar,
      required this.registrarNuevo,
      required this.refrescarPagina,
      required this.isListEmpty,
      required this.listado,
      required this.listadoWidget,
      required this.textLoading,
      this.isIconRequired = true,
      this.withBottomRefresh = true,
      this.isRequiredQuery = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (isRequiredQuery)
          BuscadorTextField(
              isIconRequired: isIconRequired,
              refrescar: () {
                refrescarPagina();
              },
              label: label,
              couterText: "Busqueda encontrada con : ${listado.length.toString()}".toUpperCase(),
              queryController: queryController,
              focusNode: focusNode,
              ejecutar: () {
                functionBuscar();
              }),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 36.0),
          child: Divider(),
        ),
        if (isLoading)
          Expanded(child: Loading(text: textLoading))
        else if (!isLoading && !httpResponsse.isRequest)
          PageResponse(httpResponsse: httpResponsse)
        else if (!isLoading && listado.isEmpty)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              queryController.text.isNotEmpty
                  ? Text(
                      "No se encontraron datos con: ${queryController.text}".toUpperCase(),
                      style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
                    )
                  : Text(
                      "No se encuentran datos registrados".toUpperCase(),
                      style: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 12),
                    ),
              Container(
                width: (MediaQuery.of(context).size.height / 2) - 40,
                padding: const EdgeInsets.only(top: 12),
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.blueAccent)),
                    onPressed: () {
                      if (queryController.text.isEmpty) {
                        registrarNuevo();
                      } else {
                        queryController.clear();
                        refrescarPagina();
                      }
                    },
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                                queryController.text.isEmpty
                                    ? "¿Deseas registrar nuevos datos?".toUpperCase()
                                    : "Recargar Pagina".toUpperCase(),
                                maxLines: 2,
                                style: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis)),
                          ),
                        ),
                        Icon(
                          queryController.text.isEmpty ? Icons.add_circle_outline : CupertinoIcons.refresh,
                          color: Colors.white,
                        )
                      ],
                    )),
              ),
            ],
          )
        else
          Expanded(child: listadoWidget)
      ],
    );
  }
}

class FloatButtonPage extends StatelessWidget {
  Function? function;
  String? tooltip;

  FloatButtonPage({super.key, this.function, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      shape: const CircleBorder(),
      onPressed: () {
        this.function!();
      },
      tooltip: tooltip!,
      child: const Icon(CupertinoIcons.add_circled, color: Colors.white, size: 33),
    );
  }
}

class ButtonFormPage extends StatelessWidget {
  Function? function;
  String textButton;
  WidgetStateProperty<Color?>? widgetStateProperty;

  ButtonFormPage({super.key, required this.textButton, this.function, this.widgetStateProperty});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FilledButton.tonal(
        style: ButtonStyle(
            elevation: WidgetStateProperty.all<double?>(6),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            backgroundColor: widgetStateProperty ?? WidgetStateProperty.all<Color>(Colors.teal)),
        onPressed: () {
          function!();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(textButton.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 16, color: Colors.white, overflow: TextOverflow.clip, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(CupertinoIcons.share_up, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
