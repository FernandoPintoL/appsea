import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import '../../app/controller/galeria_vehiculo_controller.dart';
import '../../app/controller/galeria_visitante_controller.dart';
import '../../app/providers/ingresos_provider.dart';
import '../../app/providers/vehiculo_provider.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/metodos/image_utils.dart';
import '../components/widget/appBar_title.dart';
import '../components/widget/dialog.dart';
import '../components/widget/form_button.dart';
import '../components/widget/loading.dart';
import '../vehiculo/control_vehiculo_mostrar_imagenes.dart';
import '../visita/control_visitante_mostrar_imagenes.dart';

class UploadImageVisitCar extends StatefulWidget {
  const UploadImageVisitCar({super.key});

  @override
  State<UploadImageVisitCar> createState() => _UploadImageVisitCarState();
}

class _UploadImageVisitCarState extends State<UploadImageVisitCar> {
  Uint8List? image;
  Uint8List? imageCompress;
  File? selectedImage;
  XFile? returnImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: [
            IconButton(
                style: ButtonStyle(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    shadowColor: WidgetStateProperty.all<Color>(Colors.blueGrey.shade400),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.blueGrey),
                    elevation: WidgetStateProperty.all<double>(9.0)),
                tooltip: "RECARGAR RESIDENTES",
                onPressed: () {
                  context
                      .read<VisitanteProvider>()
                      .cargarGaleriaVisitantes(context.read<IngresosProvider>().model.visitante_id);
                  if (context.read<IngresosProvider>().model.vehiculo_id != 0) {
                    context
                        .read<VehiculoProvider>()
                        .cargarGaleriaVehiculo(context.read<IngresosProvider>().model.vehiculo_id);
                  }
                },
                icon: const Icon(
                  CupertinoIcons.refresh_thick,
                  color: Colors.white,
                ))
          ],
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade700,
          title: AppBarTitle(title: "CONTROL DE GALERIAS")),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.watch<VisitanteProvider>().listImagenes.isNotEmpty ||
                (context.read<IngresosProvider>().ingresoConVehiculo &&
                    context.watch<VehiculoProvider>().listImagenes.isNotEmpty)
            ? Colors.green
            : Colors.orange,
        extendedPadding: const EdgeInsets.symmetric(horizontal: 2),
        label: Text(
          context.watch<VisitanteProvider>().listImagenes.isNotEmpty ||
                  (context.read<IngresosProvider>().ingresoConVehiculo &&
                      context.watch<VehiculoProvider>().listImagenes.isNotEmpty)
              ? "Continuar el registro".toUpperCase()
              : "CARGAR IMAGENES".toUpperCase(),
          style: const TextStyle(
              fontSize: 12, color: Colors.white, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
        ),
        icon: context.watch<VisitanteProvider>().listImagenes.isNotEmpty ||
                (context.read<IngresosProvider>().ingresoConVehiculo &&
                    context.watch<VehiculoProvider>().listImagenes.isNotEmpty)
            ? const Icon(CupertinoIcons.arrow_right, color: Colors.white)
            : const Icon(CupertinoIcons.camera, color: Colors.white),
        onPressed: () {
          if (context.read<VisitanteProvider>().listImagenes.isEmpty ||
              (context.read<IngresosProvider>().ingresoConVehiculo &&
                  context.read<VehiculoProvider>().listImagenes.isEmpty)) {
            context.read<VisitanteProvider>().image = null;
            pageUploadImage(context);
          } else {
            Navigator.pop(context);
          }
        },
      ),
      body: context.watch<VisitanteProvider>().isLoading
          ? Loading(text: context.watch<VisitanteProvider>().textLoading)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 150),
                      // PAGINA PARA CARGAR IMAGENES
                      Flexible(
                        child: FilledButton.tonal(
                            style: ButtonStyle(
                                visualDensity: VisualDensity.adaptivePlatformDensity,
                                elevation: WidgetStateProperty.all<double>(3),
                                backgroundColor: WidgetStateProperty.all<Color>(Colors.orange)),
                            onPressed: () {
                              context.read<VisitanteProvider>().image = null;
                              pageUploadImage(context);
                            },
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 3.0),
                                    child: Text("CARGAR IMAGENES",
                                        style:
                                            TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.camera,
                                  color: Colors.white,
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      context.watch<IngresosProvider>().anuncios.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          overflow: TextOverflow.clip,
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  //MUESTRA LAS GALERIAS
                  if (context.watch<IngresosProvider>().isRegisterVisitante)
                    Container(
                        height: (MediaQuery.of(context).size.height / 2) - 110,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Imagenes de visitante'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey),
                            ),
                            const Flexible(child: ControlVisitanteMostrarImagenes()),
                          ],
                        )),
                  if (context.watch<IngresosProvider>().isRegisterVehiculo)
                    Container(
                        height: (MediaQuery.of(context).size.height / 2) - 110,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Divider(color: Colors.grey),
                            Text('Imagenes de vehiculo'.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey)),
                            const Flexible(child: ControlVehiculoMostrarImagenes()),
                          ],
                        ))
                ],
              ),
            ),
    );
  }

  Future<void> showImagePickerOption(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await _pickImageFormGaleria();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 50,
                            ),
                            Expanded(child: Text("Galeria"))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await _pickImageFormCamera();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 50,
                            ),
                            Expanded(child: Text("Camara"))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _pickImageFormGaleria() async {
    returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(!mounted) return;
    if (returnImage == null) {
      Navigator.pop(context);
      DialogMessage().snackBar(context, "IMAGEN NO CARGADA", "", Colors.yellow);
      return;
    }
    setState(() {
      selectedImage = File(returnImage!.path);
      image = File(returnImage!.path).readAsBytesSync();
    });

    Uint8List? compress = await ImagesUtils().compressFile(returnImage!);
    if(!mounted) return;
    if (compress == null) {
      DialogMessage().snackBar(context, "IMAGEN NO CARGADA", "", Colors.yellow);
      Navigator.pop(context);
      return;
    }
    context.read<VisitanteProvider>().image = compress;

    Navigator.pop(context);
  }

  Future<void> _pickImageFormCamera() async {
    returnImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if(!mounted) return;
    if (returnImage == null) {
      Navigator.pop(context);
      DialogMessage().snackBar(context, "IMAGEN NO CARGADA", "", Colors.yellow);
      return;
    }

    setState(() {
      selectedImage = File(returnImage!.path);
      image = File(returnImage!.path).readAsBytesSync();
    });

    Uint8List? compress = await ImagesUtils().compressFile(returnImage!);
    if(!mounted) return;
    if (compress == null) {
      DialogMessage().snackBar(context, "IMAGEN NO COMPRIMIDA", "", Colors.yellow);
      Navigator.pop(context);
      return;
    }

    context.read<VisitanteProvider>().image = compress;

    Navigator.pop(context);
  }

  Future<void> subirImagenVisitante() async {
    context.read<VisitanteProvider>().textLoadingShowModal = "cargando imagen esperando...".toUpperCase();
    context.read<VisitanteProvider>().changeLoading(true, "Cargando imagen".toUpperCase());
    GaleriaVisitanteController galeriaVisitanteController = GaleriaVisitanteController();
    int id = context.read<IngresosProvider>().model.visitante.id;
    print(returnImage!.path);
    String extension = path.extension(returnImage!.path);
    String filename = id.toString() + extension;
    context.read<VisitanteProvider>().httpResponsse =
        await galeriaVisitanteController.dioUint8List(id, filename, context.read<VisitanteProvider>().image!);
    if(!mounted) return;
    DialogMessage().snackBar(context, context.read<VisitanteProvider>().httpResponsse.message, "",
        context.read<VisitanteProvider>().httpResponsse.isSuccess ? Colors.green : Colors.redAccent);
    context.read<VisitanteProvider>().changeLoading(false, "");
    context.read<VisitanteProvider>().changeLoading(true, "Cargando galeria".toUpperCase());
    context.read<VisitanteProvider>().cargarGaleriaVisitantes(id);
    Navigator.pop(context);
  }

  Future<void> subirImagenVehiculo() async {
    context.read<VisitanteProvider>().changeLoading(true, "CARGANDO IMAGEN DEL VEHICULO");
    int id = context.read<IngresosProvider>().model.vehiculo_id;
    String extension = path.extension(returnImage!.path);
    String filename = id.toString() + extension;
    context.read<VehiculoProvider>().httpResponsse =
        await GaleriaVehiculoController().dioUint8List(id, filename, context.read<VisitanteProvider>().image!);
    if(!mounted) return;
    DialogMessage().snackBar(context, context.read<VehiculoProvider>().httpResponsse.message, "",
        context.read<VehiculoProvider>().httpResponsse.isSuccess ? Colors.green : Colors.redAccent);
    context.read<VehiculoProvider>().cargarGaleriaVehiculo(id);

    context.read<VisitanteProvider>().textLoadingShowModal = "Cargando galeria".toUpperCase();
    context.read<VisitanteProvider>().changeLoading(false, "");

    Navigator.pop(context);
  }

  Future<void> subirImagen(BuildContext context) async {
    return await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                context.read<IngresosProvider>().isRegisterVehiculo
                    ? 'Selecciona visitante o vehiculo'.toUpperCase()
                    : 'Selecciona visitante'.toUpperCase(),
                maxLines: 3,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold)),
            content: Text(context.watch<VisitanteProvider>().textLoadingShowModal,
                maxLines: 3,
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold)),
            actions: <Widget>[
              context.watch<VisitanteProvider>().isLoading
                  ? const Center(child: Text(""))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (context.read<IngresosProvider>().isRegisterVisitante)
                            FilledButton(
                              style: ButtonStyle(
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  elevation: WidgetStateProperty.all<double?>(3),
                                  backgroundColor: WidgetStateProperty.all<Color>(Colors.blue)),
                              child: Text('subir visitante'.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis)),
                              onPressed: () async {
                                await subirImagenVisitante();
                                // context.read<IngresosProvider>().changeShowGalerias();
                                // imageCompress = null;
                              },
                            ),
                          if (context.read<IngresosProvider>().isRegisterVehiculo)
                            FilledButton(
                              style: ButtonStyle(
                                  visualDensity: VisualDensity.adaptivePlatformDensity,
                                  elevation: WidgetStateProperty.all<double?>(3),
                                  backgroundColor: WidgetStateProperty.all<Color>(Colors.green)),
                              child: Text('subir vehiculo'.toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis)),
                              onPressed: () async {
                                await subirImagenVehiculo();
                              },
                            ),
                        ],
                      ),
                    )
            ],
          );
        });
  }

  Future<void> pageUploadImage(BuildContext context) async {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Text(
                    "Sube Imagenes desde tu galeria o captura una".toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.blueGrey, overflow: TextOverflow.clip, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                    child: Stack(
                      children: [
                        // IMAGEN COMPRIMIDA
                        if (context.watch<VisitanteProvider>().image != null && !kIsWeb)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.memory(
                              width: MediaQuery.of(context).size.width - 80,
                              height: MediaQuery.of(context).size.width - 80,
                              fit: BoxFit.cover,
                              context.watch<VisitanteProvider>().image!,
                            ),
                          )
                        else
                          //SI NO HAY IMAGEN CARGADA
                          ClipOval(
                            child: Container(
                              width: MediaQuery.of(context).size.width - 200,
                              height: MediaQuery.of(context).size.width - 200,
                              child: Material(
                                  color: Colors.blueAccent.withOpacity(0.1),
                                  child: const Icon(
                                    CupertinoIcons.camera_viewfinder,
                                    color: Colors.white,
                                    size: 150,
                                  )),
                            ),
                          ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Colors.orange)),
                                onPressed: () {
                                  showImagePickerOption(context);
                                },
                                icon: const Icon(
                                  Icons.camera_enhance_outlined,
                                  color: Colors.white,
                                  size: 35,
                                ))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: FormButtom(
                      color: Colors.orange,
                      ejecutar: () async {
                        if (context.read<VisitanteProvider>().image == null) {
                          Navigator.pop(context);
                          DialogMessage().snackBar(context, "NO SE REGISTRO NINGUNA IMAGEN", "", Colors.redAccent);
                          return;
                        } else {
                          await subirImagen(context);
                          if(!context.mounted) return;
                          Navigator.pop(context);
                        }
                      },
                      title: "Cargar Imagen",
                      icon: const Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          );
        });
  }
}
