import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/providers/vehiculo_provider.dart';
import '../components/widget/image_component.dart';
import '../components/widget/loading.dart';
import '../components/widget/text_descriptivo.dart';

class ControlVehiculoMostrarImagenes extends StatefulWidget {
  const ControlVehiculoMostrarImagenes({super.key});

  @override
  State<ControlVehiculoMostrarImagenes> createState() => _ControlVehiculoMostrarImagenesState();
}

class _ControlVehiculoMostrarImagenesState extends State<ControlVehiculoMostrarImagenes> {
  @override
  Widget build(BuildContext context) {
    return context.watch<VehiculoProvider>().isLoading
        ? Loading(text: context.read<VehiculoProvider>().textLoading)
        : context.watch<VehiculoProvider>().listImagenes.isEmpty
            ? Center(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_enhance_outlined),
                  Text(
                    "No tiene imagenes subidas del vehiculo".toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, overflow: TextOverflow.clip),
                  ),
                ],
              ))
            : GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemCount: context.read<VehiculoProvider>().listImagenes.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Flexible(
                        child: Stack(
                          children: [
                            ImageComponent(
                                function: () {},
                                imageUrl: context.read<VehiculoProvider>().listImagenes[index].photo_path,
                                errorWidget: CircleAvatar(
                                    child: Icon(
                                  size: 150,
                                  Icons.dangerous_outlined,
                                )),
                                size: MediaQuery.of(context).size.width - 150),
                            /*Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                    color: Colors.deepOrange.shade600,
                                    onPressed: () {
                                      // showImagePickerOption(context);
                                    },
                                    icon: Icon(Icons.dangerous_outlined,
                                        color: Colors.redAccent))),*/
                          ],
                        ),
                      ),
                      /*TextDescriptivo(
                        title: "ID: ",
                        subtitle: context.read<VehiculoProvider>().listImagenes[index].id.toString(),
                      ),*/
                      TextDescriptivo(
                        title: "",
                        subtitle: context.read<VehiculoProvider>().listImagenes[index].fechaCreado() +
                            " " +
                            context.read<VehiculoProvider>().listImagenes[index].horaCreado(),
                      ),
                      /*TextDescriptivo(
                    title: "",
                    subtitle: context
                        .read<VisitanteProvider>()
                        .listImagenes[index]
                        .detalle,
                  ),*/
                    ],
                  );
                },
              );
  }
}
