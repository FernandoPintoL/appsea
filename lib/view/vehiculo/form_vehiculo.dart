import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/providers/vehiculo_provider.dart';
import '../components/metodos/CustomTextFormField.dart';
import '../components/metodos/UpperCaseTextFormatter.dart';
import '../components/widget/customTextFormField.dart';
import '../components/widget/loading.dart';
import '../components/widget/widgets_styles.dart';
import '../config/pallet.dart';
import 'cargar_imagen_vehiculo.dart';
import 'list_vehiculos.dart';

class FormNewVehiculo extends StatefulWidget {
  const FormNewVehiculo({super.key});

  @override
  State<FormNewVehiculo> createState() => _FormNewVehiculoState();
}

class _FormNewVehiculoState extends State<FormNewVehiculo> {
  @override
  Widget build(BuildContext context) {
    return context.watch<VehiculoProvider>().isLoading
        ? Loading(text: context.read<VehiculoProvider>().textLoading)
        : Form(
            key: context.watch<VehiculoProvider>().formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: defaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text("REGISTRAR VEHICULO",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.blueGrey,
                                overflow: TextOverflow.clip,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic)),
                      ),
                      CargarImagenVehiculo(),
                    ],
                  ),
                ),
                //PLACA
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      CustomFormField(
                        textController: context.watch<VehiculoProvider>().placaController,
                        typeText: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        hintText: "001ABC",
                        label: const Text("Placa:"),
                        errorText: context.watch<VehiculoProvider>().model.placaError,
                        icon: context.watch<VehiculoProvider>().isLoadingSelect
                            ? const CircularProgressIndicator()
                            : const Icon(CupertinoIcons.car_detailed),
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        validator: (value) => CustomText().isValidPlaca(value!),
                        onChanged: (value) {
                          print("ESCUCHO LOS CAMBIOS");
                          context.read<VehiculoProvider>().searchVehiculoCreate();
                        },
                      ),
                      Visibility(
                          visible: context.watch<VehiculoProvider>().lista.isNotEmpty,
                          child: Container(
                            decoration: WidgetStyles().boxDecorationSearch(),
                            constraints: const BoxConstraints(maxHeight: 220),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            child: const ListVehiculos(),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                //TIPOVEHICULO
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TIPO DE VEHICULO
                      const Text(
                        "Tipo de vehiculo",
                        style: TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.clip),
                      ),
                      DropdownButton<String>(
                        value: context.read<VehiculoProvider>().tipoVehiculo,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        // style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          // context.read<VehiculoProvider>().cargarTipoVehiculo(value!);
                          context.read<VehiculoProvider>().tipoVehiculo = value!;
                        },
                        isExpanded: true,
                        items: context
                            .read<VehiculoProvider>()
                            .tipoVehiculos
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value.toUpperCase(),
                              style: const TextStyle(overflow: TextOverflow.clip),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                if (context.watch<VehiculoProvider>().image != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.memory(
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          context.watch<VehiculoProvider>().image!,
                        ),
                      ),
                    ),
                  )
              ],
            ));
  }
}
