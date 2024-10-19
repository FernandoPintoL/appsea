import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/models/tipo_documento_model.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/metodos/CustomTextFormField.dart';
import '../components/widget/customTextFormField.dart';
import '../components/widget/loading.dart';
import 'cargar_image_visitante.dart';

class FormNewVisitante extends StatefulWidget {
  const FormNewVisitante({super.key});

  @override
  State<FormNewVisitante> createState() => _FormNewVisitanteState();
}

class _FormNewVisitanteState extends State<FormNewVisitante> {
  late FocusNode focusName;
  late FocusNode focusNroDoc;
  late FocusNode focusCelular;
  late FocusNode focusTipoDoc;

  @override
  void initState() {
    super.initState();
    focusName = FocusNode();
    focusNroDoc = FocusNode();
    focusCelular = FocusNode();
    focusTipoDoc = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    focusName.dispose();
    focusNroDoc.dispose();
    focusCelular.dispose();
    focusTipoDoc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<VisitanteProvider>().isLoading
        ? Loading(text: context.read<VisitanteProvider>().textLoading)
        : Form(
            key: context.read<VisitanteProvider>().formKey,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text("REGISTRAR NUEVO VISITANTE",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                    ),
                    CargarImageVisitante()
                  ],
                ),
                //NOMBRE
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  child: CustomFormField(
                    textController: context.watch<VisitanteProvider>().nameController,
                    typeText: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    focusNode: focusName,
                    hintText: "Juan Perez",
                    label: Text("Nombre:".toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                    icon: const Icon(CupertinoIcons.person, weight: 3),
                    onTapOutside: (event) {
                      focusName.unfocus();
                    },
                    validator: (value) => CustomText().isValidName(value!),
                    // onChanged: (value) => CustomText().isValidName(value!),
                  ),
                ),
                //NRODEDOCUMENTO
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TIPO DE DOCUMENTO
                      if (context.read<VisitanteProvider>().listTipoDocumento.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Seleccione un tipo de documento".toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<TipoDocumento>(
                              focusNode: focusTipoDoc,
                              value: context.watch<VisitanteProvider>().tipoDocumento,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              onChanged: (TipoDocumento? value) {
                                // This is called when the user selects an item.
                                context.read<VisitanteProvider>().cargarDataTipoDocumento(value!);
                                context.read<VisitanteProvider>().tipoDocumento = value;
                              },
                              isExpanded: true,
                              items: context
                                  .read<VisitanteProvider>()
                                  .listTipoDocumento
                                  .map<DropdownMenuItem<TipoDocumento>>((TipoDocumento value) {
                                return DropdownMenuItem<TipoDocumento>(
                                  value: value,
                                  child: Text(
                                    value.detalle.toUpperCase(),
                                    style: const TextStyle(overflow: TextOverflow.clip),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CustomFormField(
                          textController: context.watch<VisitanteProvider>().nroDocumentoController,
                          typeText: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: focusNroDoc,
                          onTapOutside: (event) {
                            focusNroDoc.unfocus();
                          },
                          label: Text("Nro de Documento".toUpperCase()),
                          hintText: "89568887",
                          errorText: context.watch<VisitanteProvider>().model.nroDocumentoError,
                          validator: (value) => CustomText().isValidNumDoc(value),
                          // onChanged: (value) => CustomText().isValidNumDoc(value),
                          icon: const Icon(CupertinoIcons.doc_circle),
                        ),
                      ),
                    ],
                  ),
                ),
                //CELULAR
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CustomFormField(
                    textController: context.watch<VisitanteProvider>().celularController,
                    typeText: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    focusNode: focusCelular,
                    onTapOutside: (event) {
                      focusCelular.unfocus();
                    },
                    label: const Text("Celular"),
                    hintText: "73682145",
                    icon: const Icon(CupertinoIcons.phone_fill),
                    validator: (String? value) => CustomText().isValidNumCelular(value),
                    // onChanged: (String? value) => CustomText().isValidNumCelular(value),
                  ),
                ),
                // IMAGEN VISITANTE
                if (context.watch<VisitanteProvider>().image != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          context.watch<VisitanteProvider>().image!,
                        ),
                      ),
                    ),
                  )
              ],
            ));
  }
}
