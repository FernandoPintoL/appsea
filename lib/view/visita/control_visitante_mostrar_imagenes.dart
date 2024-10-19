import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/widget/image_component.dart';
import '../components/widget/text_descriptivo.dart';

class ControlVisitanteMostrarImagenes extends StatefulWidget {
  const ControlVisitanteMostrarImagenes({super.key});

  @override
  State<ControlVisitanteMostrarImagenes> createState() => _ControlVisitanteMostrarImagenesState();
}

class _ControlVisitanteMostrarImagenesState extends State<ControlVisitanteMostrarImagenes> {
  @override
  Widget build(BuildContext context) {
    return context.watch<VisitanteProvider>().listImagenes.isEmpty
        ? Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_enhance_outlined),
              Text(
                "No tiene imagenes subidas del visitante".toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, overflow: TextOverflow.clip),
              )
            ],
          ))
        : GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            itemCount: context.read<VisitanteProvider>().listImagenes.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Flexible(
                    child: Stack(
                      children: [
                        ImageComponent(
                            function: () {},
                            imageUrl: context.read<VisitanteProvider>().listImagenes[index].photo_path,
                            errorWidget: CircleAvatar(
                                child: Icon(
                              Icons.info_outline,
                            )),
                            size: MediaQuery.of(context).size.width - 150),
                      ],
                    ),
                  ),
                  TextDescriptivo(
                    title: "",
                    subtitle: context.read<VisitanteProvider>().listImagenes[index].fechaCreado() +
                        " " +
                        context.read<VisitanteProvider>().listImagenes[index].horaCreado(),
                  ),
                ],
              );
            },
          );
  }
}
