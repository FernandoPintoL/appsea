import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../app/providers/vehiculo_provider.dart';
import '../components/metodos/image_utils.dart';
import '../components/widget/dialog.dart';
import '../components/widget/loading.dart';

class CargarImagenVehiculo extends StatefulWidget {
  const CargarImagenVehiculo({super.key});

  @override
  State<CargarImagenVehiculo> createState() => _CargarImagenVehiculoState();
}

class _CargarImagenVehiculoState extends State<CargarImagenVehiculo> {
  Uint8List? image;
  Uint8List? imageCompress;
  File? selectedImage;
  XFile? returnImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Colors.orange,
        child: IconButton(
            onPressed: () {
              showImagePickerOption(context);
            },
            icon: const Icon(CupertinoIcons.camera, color: Colors.white)));
  }

  Future<void> showImagePickerOption(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return context.watch<VehiculoProvider>().isLoading
              ? Loading(text: context.watch<VehiculoProvider>().textLoading)
              : SizedBox(
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
    // context.read<VehiculoProvider>().changeLoading(true, "Cargando Imagen");
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
      DialogMessage().snackBar(context, "IMAGEN NO COMPRIMIDA", "", Colors.yellow);
      Navigator.pop(context);
      return;
    }
    setState(() {
      context.read<VehiculoProvider>().image = compress;
      context.read<VehiculoProvider>().returnImage = returnImage!;
    });
    // context.read<VehiculoProvider>().changeLoading(false, "");
    Navigator.pop(context);
  }

  Future<void> _pickImageFormCamera() async {
    // context.read<VehiculoProvider>().changeLoading(true, "Cargando Imagen");
    returnImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if(!mounted) return;
    if (returnImage == null) {
      Navigator.pop(context);
      DialogMessage().snackBar(context, "IMAGEN NO COMPRIMIDA", "", Colors.yellow);
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
    setState(() {
      context.read<VehiculoProvider>().image = compress;
      context.read<VehiculoProvider>().returnImage = returnImage!;
    });

    // context.read<VehiculoProvider>().changeLoading(false, "");
    Navigator.pop(context);
  }
}
