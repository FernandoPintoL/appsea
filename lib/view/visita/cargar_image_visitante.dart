import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../app/providers/vistante_providers.dart';
import '../components/metodos/image_utils.dart';
import '../components/widget/dialog.dart';

class CargarImageVisitante extends StatefulWidget {
  const CargarImageVisitante({super.key});

  @override
  State<CargarImageVisitante> createState() => _CargarImageVisitanteState();
}

class _CargarImageVisitanteState extends State<CargarImageVisitante> {
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
      DialogMessage().snackBar(context, "IMAGEN NO COMPRIMIDA", "", Colors.yellow);
      Navigator.pop(context);
      return;
    }
    context.read<VisitanteProvider>().image = compress;
    context.read<VisitanteProvider>().returnImage = returnImage!;

    Navigator.pop(context);
  }

  Future<void> _pickImageFormCamera() async {
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
    /*setState(() {
      imageCompress = compress;
    });*/

    context.read<VisitanteProvider>().image = compress;
    context.read<VisitanteProvider>().returnImage = returnImage!;

    Navigator.pop(context);
  }
}
